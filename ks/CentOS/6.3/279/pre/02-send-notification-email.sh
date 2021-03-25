#!/bin/sh

# http://www.thegeekstuff.com/2012/04/curl-examples/
# curl --mail-from blah@test.com --mail-rcpt foo@test.com smtp://mailserver.com


function compose_email {
  mysname=$(hostname)
  mylname=$(hostname -f)
  myuptime=$(uptime)
  mynetdev=$(route -n|grep '^0.0.0.0'|awk '{print $8}')
  myip=$(ifconfig $mynetdev|grep 'inet addr:'|awk '{sub(/addr:/,""); print $2}')

cat <<- EOD
	Subject: Birth of a new system \($mysname\)
	--------  THIS IS AN AUTOMATICALLY GENERATED MESSAGE. DO NOT REPLY.  --------
	Congratulations!

	This email is to notify you that a new system has come on line. Its name is
	$mylname and it has been up for $myuptime.
	
	IP Address of this system on $mynetdev is: $myip

	Following is the TCP/IP configuration:
	$(ip -f inet addr)

	Another e-mail will be sent when Operating System build has been finished.

EOD

} # -- end function compose_email

echo "== Sending start of build e-mail."

grep 'localbuild' /proc/cmdline 2>/dev/null 1>/dev/null

if [ $? -ne 0 ] ; then

  optfile=$(IFS=- ; set -- $(hostname) ; echo ${1}-${2}-${3}/${4}.opt)
  /usr/bin/curl -v -o /tmp/host.opt http://kpCloud-ks:8080/vapps/${optfile}
  emaildids="$(. /tmp/host.opt ; echo $EMAIL $MAILCC | sed -e 's/[+,;:-]/ /g')"

  for emailid in $emaildids ; do
    mailto=$(IFS=@ ; set -- $emailid ; echo ${1}'@'${2:-us.kpcloud.org})
    compose_email | curl -v --mail-rcpt $mailto smtp://smtp.kpcloud.org
  done

fi

