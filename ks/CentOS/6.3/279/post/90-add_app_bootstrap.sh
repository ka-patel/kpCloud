#!/bin/sh
echo "== Adding bootstrap script to init"

RC=/etc/rc.d/init.d

bsscriptname=KP-bootstrap
bsscript=${RC}/${bsscriptname}
touch $bsscript

cat > $bsscript << 'EOF'
#!/bin/sh
#
# KP-bootstrap - this script triggers kpCloud app build if first time
#
# chkconfig: 3 99 1
# description: kpCloud UNIX boot time application build script.

# Source function library.
. /etc/init.d/functions

KPBS=/var/log/kpCloud/bs
bcount=$KPBS/bootcount
ccount=$KPBS/cleanboot

echo && echo "Starting kpCloud's Cloud bootstrap:"

bootstrap() {
  if [ ! -e $bcount ] ; then
    
    mkdir -p $KPBS
    touch $bcount
    touch $ccount
  
    oldifs=$IFS
    
    IFS='-'
    set -- $(hostname)

    grep -q -i 'localbuild=' /var/log/kpCloud/ks/cmdline 2>/dev/null 1>/dev/null
    if [ $? -eq 0 ] ; then
      echo -n '   Locally build host.'
      vappdir="${1}-${2}-${3}-local"
      shift 3
      vappguest=$(echo $@ | sed -e 's/[0-9][0-9]$//g' -e 's/[ ]/-/g')
    else
      echo -n '   Cloud build host.'
      vappdir="${1}-${2}-${3}"
      shift 3
      vappguest=$(echo $@ | sed -e 's/[ ]/-/g')
    fi

    IFS=$oldifs
  
    nowis=$(date +%Y%m%d-%H%M%S)
  
    curl -v -o $KPBS/bootstrap.sh -k https://kpCloud-ks:8080/vapps/${vappdir}/${vappguest}.cmd >$KPBS/curl.log 2>&1
    starttime=$(date +"%s")
    openvt -s -w -c 3 -- su - -c "cp -rp $KPBS/bootstrap.sh . ; cat bootstrap.sh | sh -x 2>&1 | tee build.log.$nowis" kpapp
    endtime=$(date +"%s")
    deltatime=$(($endtime - $starttime))
    runtime=$(echo - | awk -v "S=$deltatime" '{printf "%dh:%dm:%ds",S/(60*60),S%(60*60)/60,S%60}')
    
    echo -n $"     Bootstrap took $runtime to execute."
  
  else
  
    echo -n $"     Skipped. Previously executed bootstrap found."
  
  fi

  return 0

}
  
case $1 in
  start)
    bootstrap && success || failure
    count=$(cat $ccount)
    count=$(( $count + 1 ))
    echo $count > $ccount
    ;;
  stop)
    count=$(cat $ccount)
    count=$(( $count - 1 ))
    echo $count > $ccount
    ;;
esac

count=$(cat $bcount)
count=$(( $count + 1 )) 
echo $count > $bcount

exit 0
EOF

chmod u+x $bsscript
chkconfig --add $bsscriptname

exit 0
