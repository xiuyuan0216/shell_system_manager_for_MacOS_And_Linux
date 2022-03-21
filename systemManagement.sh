#!/bin/bash

os_check(){
   systemName=$(uname -s)
   case "$systemName" in 
     Linux) os=Linux;;
     Darwin) os=MacOS;;
     *) os=Windows;;
   esac
   versionName=$(uname -r)
   osfullName="$os $versionName"
}
os_check
while true; do
  select input in operating_system_information cpu_information cpu_load mem_use tcp_status cpu_top10  quit; do
     case $input in
          operating_system_information) 
               echo "-----------------------------------------"
               echo $osfullName
             ;;
          cpu_information)
              if [ $os = "MacOS" ]; then
                 cpuname=`system_profiler SPHardwareDataType|awk '{if(NR == 7) print $2 " " $3}'`
                 corenumber=`system_profiler SPHardwareDataType|awk '{if(NR == 8) print $5}'`
                 echo "-----------------------------------------"
                 echo "CPU Information"
                 echo $corenumber " " $cpuname
              elif [ $os = "Linux" ]; then
                 cpu=`cat /proc/cpuinfo|grep name|cut -f2 -d:|uniq -c`
                 echo "-----------------------------------------"
                 echo "CPU Information"
                 echo $cpu
              fi
             ;;
          cpu_load)
             if [ $os = "MacOS" ]; then
                 LoadAve1=`top|head -n 10|awk '{if(NR == 3)print $3}'`
                 LoadAve2=`top|head -n 10|awk '{if(NR == 3)print $4}'`
                 LoadAve3=`top|head -n 10|awk '{if(NR == 3)print $5}'`
                 CPUused=`top|head -n 10|awk '{if(NR == 4)print $3}'`
                 CPUidle=`top|head -n 10|awk '{if(NR == 4)print $7}'`
                 echo "------------------------------------------"
                 echo "One minute CPU Load Value: $LoadAve1"
                 echo "Five minutes CPU Load Value: $LoadAve2"
                 echo "Fifteen minutes CPU Load Value: $LoadAve3"
                 echo "CPU used: $CPUused"
                 echo "CPU idle: $CPUidle"
             elif [ $os = "Linux" ]; then
                 LoadAve4=`uptime|awk '{if(NR == 1)print $10}'`
                 LoadAve5=`uptime|awk '{if(NR == 1)print $11}'`
                 LoadAve6=`uptime|awk '{if(NR == 1)print $12}'`
                 CPUused2=`vmstat|awk '{if(NR == 3)print $15}'`
                 echo "------------------------------------------"
                 echo "One minute CPU Load Value: $LoadAve4"
                 echo "Five minutes CPU Load Value: $LoadAve5"
                 echo "Fifteen minutes CPU Load Value: $LoadAve6"
                 echo "CPU used: $((100-$CPUused2))%"
                 echo "CPU idle: $CPUused2%"
             fi 
              ;;
          mem_use)
              if [ $os = "MacOS" ]; then
                memoTotal=`system_profiler SPHardwareDataType|awk '{if(NR == 9) print $2}'`
                memoUsed=`top|head -n 10|awk '{if(NR == 7)print $2}'`

                memoUnused=`top|head -n 10|awk '{if(NR == 7)print $6}'`
                echo "-----------------------------------------"
                echo "Total memory: $((memoTotal*1024)) M"
                echo "Memory used: $memoUsed"
                echo "Memory not used: $memoUnused"
              elif [ $os = "Linux" ]; then
                memoTotal2=`free -m|awk '{if(NR == 2)print $2}'`
                memoUsed2=`free -m|awk '{if(NR == 2)print $3}'`
                memoUnused2=`free -m|awk '{if(NR == 2)print $4}'`
                echo "----------------------------------------"
                echo "Total memory: $memoTotal2 M"
                echo "Memory used: $memoUsed2 M"
                echo "Memory not used: $memoUnused2 M"
              fi
              ;;
          tcp_status)
              if [ $os = "MacOS" ]; then
                echo "--------------------------------------"
                count=`netstat|awk '{if($1 == "tcp4") status[$6]++}END{for(i in status) print i, status[i]}'`
                echo -e "TCP connection status: \n$count"
              elif [ $os = "Linux" ]; then
                echo "---------------------------------------"
                count2=`ss -ant|awk '{if(NR != 1) status[$1]++}END{for(i in status) print i, status[i]}'`
                echo -e "TCP connection status: \n$count2"
              fi  
               ;;
          cpu_top10)
               if [ $os = "MacOS" ]; then
                cputop=`ps aux|awk '{if($3>0.1) print $1 " " $2 " " $3}'|sort -k3 -nr`   
                echo "---------------------------------------"
                echo "Process Name   " "PID   " "CPU Percentage   "
                echo "$cputop"
               elif [ $os = "Linux" ]; then
                cputop2=`ps aux|awk '{if($3>0.1) print $1 " " $2 " " $3}'|sort -k3 -nr`
                echo "---------------------------------------"
                echo "Process Name   " "PID   " "CPU Percentage   "
                echo "$cputop2"
               fi
               ;;
          quit) exit;;
          *) echo "Invalid Input"
             exit
           ;;
     esac
  done
done

