#!/bin/sh
ulimit -u 150
killer()
{
	killall a.out
	VAR1=$(expr $(pgrep -o crap) - 1)
	VAR2=$(pgrep -o crap)
	echo $VAR1
	echo $VAR2
	pkill -1 -g $VAR1
	pkill -1 -g $VAR2
	echo "Killed"
	rm -rf *.poo
	echo "Cleaned"
}
./manger & killer

