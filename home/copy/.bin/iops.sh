#! /bin/bash

cache_dir="$HOME/.cache/iops"
mkdir -p "$cache_dir"

disk="$1"
dir="$2"
if [[ "$disk" == "" ]]
then
	echo "please provide a disk"
	exit 1
fi

rios=0
wios=0
t=0

file="$cache_dir/$disk"
if [[ "$dir" != "" ]]
then
	file="$file-$dir"
fi

if [[ -e "$file" ]]
then
	source "$file"
fi

t_now=`date +%s.%N`
arr=(`cat /proc/diskstats | grep " $disk "`)
rios_now="${arr[3]}"
wios_now="${arr[7]}"

dt=`bc -l <<< "$t_now - $t"`
riops=`bc <<< "scale=2; ($rios_now - $rios) / $dt"`
wiops=`bc <<< "scale=2; ($wios_now - $wios) / $dt"`
printf "rios=$rios_now\nwios=$wios_now\nt=$t_now" > "$file"

#echo "read iops: $riops, write iops: $wiops, dt: $dt"
case "$dir" in
"r" | "R")
	echo "$riops"
	;;
"w" | "W")
	echo "$wiops"
	;;
*)
	echo "$riops	$wiops"
	;;
esac
