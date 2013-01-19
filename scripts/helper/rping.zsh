tmp=$1
start=()
start[1]=`echo $tmp | cut -d'.' -f1`
start[2]=`echo $tmp | cut -d'.' -f2`
start[3]=`echo $tmp | cut -d'.' -f3`
start[4]=`echo $tmp | cut -d'.' -f4`
tmp=$2
stop[1]=`echo $tmp | cut -d'.' -f1`
stop[2]=`echo $tmp | cut -d'.' -f2`
stop[3]=`echo $tmp | cut -d'.' -f3`
stop[4]=`echo $tmp | cut -d'.' -f4`

trap "exit 1;" SIGINT

while [[ ${start[4]} -le ${stop[4]} && ${start[2]} -le ${stop[2]} && ${start[3]} -le ${stop[3]} && ${start[1]} -le ${stop[1]} ]];
do
	ip="${start[1]}.${start[2]}.${start[3]}.${start[4]}"
	ping -c1 -W100 $ip 2>&1 > /dev/null
	if [ "$?" -eq "0" ]; then
		echo $ip
	fi
	start[4]=$(( ${start[4]} + 1 ))
	if [ ${start[4]} -eq 255 ]; then
		start[4]=1
		start[3]=$(( ${start[3]} + 1 ))
		if [ ${start[3]} -eq 255 ]; then
			start[3]=1
			start[2]=$(( ${start[2]} + 1 ))
			if [ ${start[2]} -eq 255 ]; then
				start[2]=1
				start[1]=$(( ${start[1]} + 1 ))
				if [ ${start[1]} -eq 255 ]; then
					exit;
				fi
			fi
		fi
	fi
done
