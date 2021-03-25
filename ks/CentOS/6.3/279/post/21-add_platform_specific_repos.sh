#!/bin/sh
echo "== Adding platform specific repos..."

manufact=$(dmidecode -s system-manufacturer | sed -e 's/ //g')
echo "    \$manufact=$manufact"

case $manufact in
  'Dell')
    echo "  -> Adding Dell OpenManage Repo"
    curl -q http://linux.dell.com/repo/hardware/latest/bootstrap.cgi | bash
  ;;
  
  'VMware,Inc.')
    echo "  -> Adding VMWare Repo"
    yum -y --nogpgcheck --noplugins install vmware-tools-repo-RHEL6
  ;;

  'HP')
    # See http://downloads.linux.hp.com/SDR/ and
    # http://downloads.linux.hp.com/SDR/repo/ for listing
    # http://downloads.linux.hp.com/SDR/project/ for listing
    echo "  -> Adding HP SDR Repo"
    rpm --import http://downloads.linux.hp.com/SDR/hpPublicKey1024.pub
    rpm --import http://downloads.linux.hp.com/SDR/hpPublicKey2048.pub

    cat <<- EOF > /etc/yum.repos.d/hpsum.repo
	[hpsum]
	name=HP Smart Update Manager
	baseurl=http://downloads.linux.hp.com/repo/hpsum/rhel/$releasever/$basearch/current
	enabled=1
	gpgcheck=1
	gpgkey=file:///etc/pki/rpm-gpg/GPG-KEY-hpsum
	EOF

    yum -y install hpsum

    wget -O add_repo.sh http://downloads.linux.hp.com/SDR/add_repo.sh
    for repo in mcp mlnx_ofed stk ; do 
      sh ./add_repo.sh $repo
    done
    for repo in hpsum mcp mlnx_ofed spp stk ; do 
      for pkg in $(yum -q --disablerepo="*" --enablerepo="HP-$repo" list available | awk '{print $1}' | cut -d. -f1) ; do
        yum -y install $pkg 
      done
    done
  ;;
  
esac

exit 0
