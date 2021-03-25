#!/bin/sh

echo "== Creating kpCloud cron jobs."

function insert_cron_job { 

  crontype=$1  
  echo '     insert_cron_job:$crontype='$crontype

  cat <<- EOF > /etc/cron.${crontype}/kpCloud
	#!/bin/sh

	logdir=/var/log/kpCloud/janitor.d/${crontype}
	mkdir -p \$logdir

	exec 2>&1 > \$logdir/janitor.log

	date
	janitordir=/etc/kpCloud.d/etc/janitor.d/${crontype}

	[ -d \$janitordir ] || exit 0

	cd \$janitordir

	for jjob in [0-9][0-9]* ; do 
	  echo "-- [ \$jjob ] -- "
	  ((date ; ./\${jjob} 2>&1 ) >\$logdir/\${jjob}.log) & 
	done

	EOF

  chmod u+x /etc/cron.${crontype}/kpCloud

} # - End function insert_cron_job

for jobtype in hourly daily weekly monthly ; do
  echo '     $jobtype='$jobtype
  insert_cron_job $jobtype
done

exit 0
