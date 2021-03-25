#!/bin/sh
echo "== Setting HW clock to be set up as UTC."

# Change the value of the UTC variable below to a value of 0 (zero) if the hardware clock is not set to UTC time.
#
# If you cannot remember whether or not the hardware clock is set to UTC, find out by running the 
# hwclock --localtime --show command. This will display what the current time is according to the hardware clock. 
# If this time matches whatever your watch says, then the hardware clock is set to local time. If the output 
# from hwclock is not local time, chances are it is set to UTC time. Verify this by adding or subtracting the 
# proper amount of hours for the timezone to the time shown by hwclock. For example, if you are currently in the 
# MST timezone, which is also known as GMT -0700, add seven hours to the local time.

cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
EOF

exit 0
