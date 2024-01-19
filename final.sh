#!/bin/bash
rtime=`date +%H:%M:%S-%d.%m.%Y`

func_help () {
        echo "Данный скрипт необходим для мониторинга ресурсов сервера"
        echo "-p, --proc - работа с директорией /proc"
        echo "-c, --cpu - работа с процессором"
        echo "-m, --memory - работа с памятью"
        echo "-d, --disks - работа с дисками"
        echo "-n, --network - работа с сетью"
        echo "-la, --loadaverage - вывод средней нагрузки на систему"
        echo "-k, --kill - отправка сигналов процессам (простой аналог утилиты kill)"
        echo "-out, --output-file - сохранение результатов работы скрипта на диск (если хотите воспользоваться данной функцией, добавьте ее самым последним параметром, и результат работы скрипта запишется в лог)"
        echo "-h, --help - вывод предназначения скрипта, помощи для верного запуска и описания всех команд"
        echo "-e, --examples - показ примеров работы различных команд"
        }

func_examples () {
	echo "Примеры для работы с командами"
	exam_proc
	exam_cpu
	exam_mem
	exam_disks
	exam_net
	exam_la
	exam_kill
}

exam_proc () {
	echo " "
	echo "Примеры для работы с командой -p"
	echo "./final.sh -p		показывает содержимое папки /proc"
	echo "./final.sh -p uptime	показывает содержимое ФАЙЛА uptime (на месте параметра должно быть имя файла) в папке /proc"
}

exam_cpu () {
	echo " "
	echo "Примеры для работы с командой -c"
	echo "./final.sh -c		показывает характеристики процессора (аналог lscpu)"
	echo "./final.sh -c -f 	показывает частоту процессора"
}

exam_mem () {
	echo " "
	echo "Примеры для работы с командой -m"
	echo "./final.sh -m		показывает состояние памяти и SWAP"
	echo "./final.sh -m used 	показывает объем используемой памяти"
}

exam_disks () {
	echo " "
	echo "Примеры для работы с командой -d"
	echo "./final.sh -d		показывает имеющиеся устройства и их параметры"
	echo "./final.sh -d -f 		показать информацию о файловых системах"
	echo "./final.sh -d -x name	сортировать вывод по <столбцу> (регистр не важен)"
}

exam_net () {
	echo " "
	echo "Примеры для работы с командой -n"
	echo "./final.sh -n		показывает имеющиеся интерфейсы на устройстве и их параметры"
	echo "./final.sh -n -r		отобразить таблицу маршрутизации"
	echo "./final.sh -n -i <interface>		показывает конкретный интерфейсе и его параметры"
	echo "./final.sh -n -i <interface> -i4		показывает на конкретном интерфейсе IPv4 address"
}

exam_la () {
	echo " "
	echo "Примеры для работы с командой -la"
	echo "./final.sh -la		показывает среднюю нагрузку за 1,5,15 мин "
	echo "./final.sh -la -m		показывает среднюю нагрузку за 1 мин "
}

exam_kill () {
	echo " "
	echo "Примеры для работы с командой -k"
	echo "./final.sh -k -L		показывает таблицу сигналов "
	echo "./final.sh -9 <PID>		посылает сигнал KILL процессу <PID> "
	echo "./final.sh -SIGKILL <PID>		посылает сигнал KILL процессу <PID> "
	echo "./final.sh -s SIGKILL <PID>		посылает сигнал KILL процессу <PID> "
	echo "./final.sh -s 9 <PID>		посылает сигнал KILL процессу <PID> "
	echo "./final.sh -l <SIGNAL>		показывает № сигнала, если введено его текстовое описание, и наоборот (без параметров выводит таблицу сигналов) "
}

func_param () {
	IFS=$'\n'
        for i in $(cat param_help)
        do
        	echo $i
        done
        rm param_help
}

func_out () {
	echo " " >> log_script
	echo "$rtime" >> log_script
	cat $1 >> log_script
}

help_proc () {
	echo "-e, --examples	показывает некоторые примеры для данной команды"
        echo "-h, --help	краткая справка"
	echo "В целом, данная команда без параметров выведет содержимое папки /proc"
	echo "Если необходимо изучить один из параметров, необходимо ввести после параметра -р имя данного файла из каталога"
}

help_cpu () {
	echo "-c, --cache	показывает кеш процессора"
        echo "-m, --model	показывает модель процессора"
  	echo "-f, --frequence	показывает частоту процессора"
        echo "-b, --bugs	выводит баги"
       	echo "-F, --flags	выводит флаги"
        echo "-s, --cache-size	показывает размер кеша"
	echo "-C, --core	показывает количество ядер"
	echo "-e, --examples	показывает некоторые примеры для данной команды"
        echo "-h, --help	краткая справка"
}

help_la () {
	echo "-m, --minute		средняя нагрузка за поседнюю минуту"
        echo "-5m, --five-minutes	средняя нагрузка за последний 5-минутный интервал"
        echo "-15m, --fifteen-minutes	средняя нагрузка за 15 минут"
	echo "-e, --example	показывает некоторые примеры для данной команды"
        echo "-h, --help		краткая справка"
}

help_int (){
	echo "-i4, --ipv4	IPv4"
	echo "-i6, --ipv6	IPv6"
	echo "-n, --netmask	maska"
	echo "-m, --mtu 	maximum transmition unit"
	echo "-b, --broadcast	broadcast address"
	echo "-f, --flags	flags"
	echo "-e, --ether	mac-address"
	echo "-r, --rx		rx traffic"
	echo "-t, --tx		tx traffic"
	echo "-h, --help	help"
}

netstat_help (){
	echo "-i, --interfaces	отобразить таблицу интерфейсов"
	echo "-l, --listen	отобразить прослушиваемые сокеты сервера"
	echo "-M, --masquerade	отобразить замаскированные соединения"
	echo "-s, --statistics 	отобразить сетевую статистику (как SNMP)"
	echo "-h, --help	help"
}

help_kill (){
	echo "-L, --table	отобразить таблицу сигналов"
	echo "-s, --signal	отправить сигнал процессу, используя его символическое имя"
	echo "-q, --queue	"
	echo "-l, --list	отобразит имя сигнала по указанному коду завершения (без данного кода выведет полный список сигналов)"
	echo "-e, --example	показывает некоторые примеры для данной команды"
	echo "-h, --help	help"
}

help_network (){
	echo "-i, --interfaces	отобразить общую информацию по интерфейсам"
	echo "-r, --route	отобразить таблицу маршрутизации"
	echo "-n, --netstate	отобразить состояние соединений"
	echo "-e, --example	показывает некоторые примеры для данной команды"
	echo "-h, --help	help"
}

killing () {
	echo "Процессу $1 послан сигнал $2"
}

if [ $1 ]; then
   case $1 in
	-p | --proc)
	if [ $2 ] && [ "$2" != "-out" ] && [ "$2" != "--output-file" ]; then
		case $2 in
		-e | --example)
		exam_proc > vyvod
		;;
		-h | --help)
		help_proc > vyvod
		;;
		*)
		if [ -f /proc/$2 ]; then
                        sudo cat /proc/$2 > vyvod
                else
			echo "@@@@@@@@@@@@@@@@@" > vyvod
                        echo "Параметр не найден! Выберите один из списка или наберите команду -h|--help:" >> vyvod
			echo "@@@@@@@@@@@@@@@@@" >> vyvod
			find /proc/ -maxdepth 1 -type f | awk -F/ '{print $3}' >> vyvod
                fi
		esac
	else
		ls /proc > vyvod
	fi
	;;

	-c | --cpu)
	if [ $2 ] && [ "$2" != "-out" ] && [ "$2" != "--output-file" ]; then
		case $2 in
			-c | --cache)
			lscpu | grep "cache" > vyvod
			;;
			-m | --model)
			cat /proc/cpuinfo | grep "model name" |uniq > vyvod
			;;
			-f | --frequence)
			cat /proc/cpuinfo |grep -i mhz | uniq > vyvod
			;;
			-b | --bugs)
			cat /proc/cpuinfo | grep bugs | uniq > vyvod
			;;
			-F | --flags)
			cat /proc/cpuinfo | grep flags | uniq > vyvod
			;;
			-s | --cache-size)
			cat /proc/cpuinfo | grep "cache size" | uniq > vyvod
			;;
			-C | --core)
			cat /proc/cpuinfo | grep "core id" > vyvod
			;;
			-h | --help)
			help_cpu > vyvod
			;;
			-e | --examples)
			exam_cpu > vyvod
			;;
			*)
			echo "@@@@@@@@@@@@@@@@@" > vyvod
			echo "Неверный параметр! Попробуйте еще раз." >> vyvod
			echo "@@@@@@@@@@@@@@@@@" >> vyvod
			help_cpu >> vyvod
		esac
	else
		lscpu > vyvod
	fi
	;;

	-m | --memory)
# организовано только для MEMORY (можно также организовать и для SWAP)
	if [ $2 ] && [ "$2" != "-out" ] && [ "$2" != "--output-file" ]; then
		case $2 in
			total)
	                free | awk '{print $2}' | sed -n 2p > vyvod
			;;
	                used)
			free | awk '{print $3}' | sed -n 2p > vyvod
			;;
	                free)
			free | awk '{print $4}' | sed -n 2p > vyvod
	                ;;
	                shared)
			free | awk '{print $5}' | sed -n 2p > vyvod
	                ;;
	                buff | cache | buff/cache)
			free | awk '{print $6}' | sed -n 2p > vyvod
	                ;;
        	        available)
			free | awk '{print $7}' | sed -n 2p > vyvod
			;;
			-e | --examples)
			exam_mem > vyvod
			;;
			*)
			echo "@@@@@@@@@@@@@@@@@" > vyvod
			echo "Параметр не найден! Выберите один из списка:" >> vyvod
			echo "@@@@@@@@@@@@@@@@@" >> vyvod
			echo "total" >> vyvod
			echo "used" >> vyvod
			echo "free" >> vyvod
			echo "shared" >> vyvod
			echo "buff/cache" >> vyvod
	                echo "available" >> vyvod
	                echo "-e | --examples (показать примеры данной функции)" >> vyvod
                	;;
		esac
	else
		free > vyvod
	fi
	;;

	-d | --disks)
	if [ $2 ] && [ "$2" != "-out" ] && [ "$2" != "--output-file" ]; then
# --параметр
param1=`(lsblk  --help | awk -F " " '{print $2}' | head -n14 | tail -n +8 && lsblk  --help | awk -F " " '{print $2}' | head -n33 | tail -n +16 && lsblk  --help | awk -F " " '{print $2}' | head -n37 | tail -n +36 && lsblk  --help | awk -F " " '{print $2}' | head -n15 | tail -n +15 | awk -F[ '{print $1}' && lsblk  --help | awk -F " " '{print $1}' | head -n34 | tail -n +34) | grep "^$2$"`
# -параметр
param2=`(lsblk  --help | awk -F "," '{print $1}' | head -n33 | tail -n +8 && lsblk  --help | awk -F "," '{print $1}' | head -n37 | tail -n +36) | grep "^ $2$"`
# аргументы для --параметра
param11=`(lsblk  --help | awk -F " " '{print $2}' | head -n10 | tail -n +9 && lsblk  --help | awk -F " " '{print $2}' | head -n19 | tail -n +19 && lsblk  --help | awk -F " " '{print $2}' | head -n26 | tail -n +26 &&  lsblk  --help | awk -F " " '{print $2}' | head -n32 | tail -n +31 && lsblk  --help | awk -F " " '{print $1}' | head -n34 | tail -n +34) | grep "^$2$"`
# аргументы для -параметра
param22=`(lsblk  --help | awk -F "," '{print $1}' | head -n10 | tail -n +9 && lsblk  --help | awk -F "," '{print $1}' | head -n19 | tail -n +19 && lsblk  --help | awk -F "," '{print $1}' | head -n26 | tail -n +26 &&  lsblk  --help | awk -F "," '{print $1}' | head -n32 | tail -n +31) | grep "^ $2$"`
# create file with necessary parameters
(lsblk  --help | awk -F "," '{print $0}' | head -n10 | tail -n +9 && lsblk  --help | awk -F "," '{print $0}' | head -n19 | tail -n +19 && lsblk  --help | awk -F "," '{print $0}' | head -n26 | tail -n +26 &&  lsblk  --help | awk -F "," '{print $0}' | head -n32 | tail -n +31 && lsblk --help | awk -F "," '{print $0}' | head -n34 | tail -n +34) > param_help
		if [ "${param1}" ] || [ "${param2}" ]; then
			if [ "${param11}" ] || [ "${param22}" ]; then
				if [ $3 ] && [ "$3" != "-out" ] && [ "$3" != "--output-file" ]; then
# столбцы
(lsblk -h | awk '{print $1}' | head -n 96 | tail -n +40) > col_file
# for list
(lsblk -o MAJ:MIN | awk -F: '{print $1}' | uniq | tail -n +2) > num_list
sed -i 's/ //g' num_list
					case $2 in
						-E | --dedup | -x | --sort)
# column
						column=`cat col_file | grep -i  "^$3$"`
						if [ ${column} ]; then
							lsblk $2 $3 > vyvod
						else
							echo "@@@@@@@@@@@@@@@@@" > vyvod
							echo "Столбец не найден. Введите один из следующих:" >> vyvod
							echo "@@@@@@@@@@@@@@@@@" >> vyvod
							cat col_file >> vyvod
						fi
						;;
						-I | --include | -e | --exclude)
# list
						echo $3 > filet
						sed -i 's/,/\n/g' filet
						for o in $(cat filet)
						do
							number=`cat num_list | grep "^$o$"`
							if [ ${number} ]; then
								echo ${number} >> file1
								numb=${number}
							fi
						done
						if [ "${numb}" == "" ]; then
							echo "@@@@@@@@@@@@@@@@@" > vyvod
							echo "Номер не найден. Введите один из следующих:" >> vyvod
							echo "@@@@@@@@@@@@@@@@@" >> vyvod
							cat num_list >> vyvod
						else
							for y in $(cat file1)
							do
								header=`cat file1 | head -n1`
								if [ "${y}" == "${header}" ]; then
									lsblk $2 $y > vyvod
								else
									lsblk $2 $y | tail -n +2 > vyvod
								fi
							done
						fi
						;;
# с выводом столбцов
						-o | --output)
						echo $3 > filet
                                                sed -i 's/,/\n/g' filet
						for u in $(cat filet)
                                                do
                                                        number=`cat col_file | grep -i "^$u$"`
                                                        if [ ${number} ]; then
                                                                echo ${number} >> file1
                                                                numb=${number}
                                                        fi
                                                done
						if [ "${numb}" == "" ]; then
                                                        echo "Столбец не найден. . Введите один из следующих:" > vyvod
                                                        cat col_file >> vyvod
                                                else
							per=`cat file1 | wc -l`
                                                        let "per=$per+1"
                                                        for ((k=1;k<$per;k++))
                                                        do
                                                        	(lsblk $2 $(cat file1 | head -n$k | tail -n +$k),name | awk '{print $1}' ) > column_$k
                                                        done
							kol_fil=`ls -l | grep "column_" | wc -l`
							let "kol_fil1=${kol_fil}+1"
							echo "#!/bin/bash" > col_all1
							sudo chmod 755 col_all1
                                                        kol_str=`cat column_1 | wc -l`
							let "kol_str=$kol_str+1"
							#echo $kol_fil
							for ((e=1;e<${kol_str};e++))
							do
								for ((y=1;y<${kol_fil1};y++))
								do
									if [ $kol_fil == 1 ]; then
										echo "(cat column_$y | head -n$e | tail -n +$e)" >> col_all
									else
										if [ $y == 1 ]; then
											echo "(" >> col_all
										fi
										if [ $y -lt $kol_fil ]; then
							        	       		echo "(cat column_$y | head -n$e | tail -n +$e) && " >> col_all
										else
							        	      		echo "(cat column_$y | head -n$e | tail -n +$e)) | xargs " >> col_all
										fi
									fi
								done
							done
							cat col_all | tr '\n' '!' | sed 's/!//g' >> col_all1
							razd=`cat col_all1 | grep "xargs" | wc -l`
							if [ $razd -gt 0 ]; then
								sed -i 's/xargs /xargs\n/g' col_all1
							else
								sed -i 's/)(/)\n(/g' col_all1
							fi
							./col_all1 > vyvod
                                                fi
						if [ -f col_all ]; then
							rm col_all
                                                fi
						if [ -f col_all1 ]; then
							rm col_all1
                                                fi
						if [ "${numb}" != "" ]; then
							for ((d=1;d<$kol_fil1;d++))
							do
								if [ -f column_$d ]; then
									rm column_$d
	                       		                        fi
							done
						fi
						;;
						-w | --width)
# width
re='^[0-9]+$'
						if [[ $3 =~ $re ]]; then
							lsblk $1 $2 $3 > vyvod
						else
							echo "@@@@@@@@@@@@@@@@@" > vyvod
							echo "Не число!" >> vyvod
							echo "@@@@@@@@@@@@@@@@@" >> vyvod
						fi
						;;
						--sysroot)
# dir
						if [ -d $3 ]; then
                                                         lsblk $1 $2 $3 > vyvod
						else
							echo "@@@@@@@@@@@@@@@@@" > vyvod
							echo "Неверная директория!" >> vyvod
							echo "@@@@@@@@@@@@@@@@@" >> vyvod
						fi
						;;
						*) func_param > vyvod
					esac
				else
					func_param > vyvod
				fi
			else
				lsblk $2 > vyvod
			fi
		else
			if [ "$2" == "-ex" ] || [ "$2" == "--example" ]; then
				exam_disks > vyvod
			else
				lsblk  --help | head -n37 | tail -n +7 > vyvod
				echo " -ex, --examples		показывает примеры использования данной команды" >> vyvod
			fi
		fi
	else
		lsblk > vyvod
	fi
	if [ -f col_file ]; then
		rm col_file
	fi
	if [ -f col_file ]; then
                rm param_help
        fi
	if [ -f file1 ]; then
        	rm file1
        fi
        if [ -f filet ]; then
	        rm filet
        fi
	;;

	-n | --network)
	(ifconfig | grep ": " | awk -F: '{print $1}') > int_list
	if [ $2 ] && [ "$2" != "-out" ] && [ "$2" != "--output-file" ]; then
		case $2 in
			-i | --interface)
			if [ $3 ] && [ "$3" != "-out" ] && [ "$3" != "--output-file" ]; then
				prin=`cat int_list | grep "$3"`
				if [ $prin ]; then
					if [ $4 ] && [ "$4" != "-out" ] && [ "$4" != "--output-file" ]; then
						case $4 in
						-i4 | --ipv4)
						ifconfig $3 | grep "inet " | awk '{print $2}' > vyvod
						;;
						-i6 | --ipv6)
						ifconfig $3 | grep "inet6 " | awk '{print $2}' > vyvod
						;;
						-n | --netmask)
						ifconfig $3 | grep "netmask " | awk '{print $4}' > vyvod
						;;
						-m | --mtu)
						ifconfig $3 | grep "mtu " | awk '{print $4}' > vyvod
						;;
						-b | --broadcast)
						ifconfig $3 | grep "broadcast " | awk '{print $6}' > vyvod
						;;
						-f | --flags)
						ifconfig $3 | grep "flags" | awk '{print $2}' > vyvod
						;;
						-e | --ether)
						ifconfig $3 | grep "ether " | awk '{print $2}' > vyvod
						;;
						-r | --rx)
						ifconfig $3 | grep -i "rx " > vyvod
						;;
						-t | --tx)
						ifconfig $3 | grep -i "tx " > vyvod
						;;
						-h | --help)
						help_int > vyvod
						;;
						*)
						echo "@@@@@@@@@@@@@@@@@" > vyvod
						echo "Неверный параметр для -i|--interface INTERFACE" >> vyvod
						echo "@@@@@@@@@@@@@@@@@" >> vyvod
						help_int >> vyvod
				#		echo help_int_into
						esac
					else
						ifconfig $3 > vyvod
					fi
				else
					echo "@@@@@@@@@@@@@@@@@" >> vyvod
					echo "Выбран несуществующий интерфейс" >> vyvod
					echo "@@@@@@@@@@@@@@@@@" >> vyvod
					echo "Выберите один из приведенных ниже интерфейсов:" >> vyvod
					cat int_list >> vyvod
				fi
			else
				echo "Выберите один из приведенных ниже интерфейсов:" >> vyvod
				cat int_list >> vyvod
			fi
			;;
			-r | --route)
			route > vyvod
			;;
			-n | --netstat)
			if [ $3 ] && [ "$3" != "-out" ] && [ "$3" != "--output-file" ]; then
		                case $3 in
				-i | --interfaces)
				netstat -i > vyvod
				;;
				-l | --listen)
				netstat -l > vyvod
				;;
				-M | --masquerade)
				netstat -M > vyvod
				;;
				-s | --statistics)
				netstat -s > vyvod
				;;
				-h | --help)
				netstat_help > vyvod
				;;
				*)
				echo "@@@@@@@@@@@@@@@@@" > vyvod
				echo "Неверный параметр" >> vyvod
				echo "@@@@@@@@@@@@@@@@@" >> vyvod
				netstat_help >> vyvod
				;;
				esac
			else
				netstat > vyvod
			fi
			;;
			-h | --help)
			help_network > vyvod
			;;
			-e | --examples)
			exam_net > vyvod
			;;
			*)
			echo "@@@@@@@@@@@@@@@@@" > vyvod
			echo "Неверный параметр" >> vyvod
			echo "@@@@@@@@@@@@@@@@@" >> vyvod
			help_network >> vyvod
		esac
	else
		ifconfig > vyvod
	fi
	if [ -f int_list ]; then
		rm int_list
	fi
	;;

	-la | --loadaverage)
	if [ $2 ] && [ "$2" != "-out" ] && [ "$2" != "--output-file" ]; then
		case $2 in
			-m | --minute)
			uptime | awk '{print $6" "$7" "$8}' > vyvod
			;;
			-5m | --five-minutes)
			uptime | awk '{print $6" "$7" "$9}' > vyvod
			;;
			-15m | --fifteen-minutes)
			uptime | awk '{print $6" "$7" "$10}' > vyvod
			;;
			-h | --help)
			help_la > vyvod
			;;
			-e | --examples)
			exam_la > vyvod
			;;
			*)
			echo "@@@@@@@@@@@@@@@@@" > vyvod
			echo "Неверно введен параметр!" >> vyvod
			echo "@@@@@@@@@@@@@@@@@" >> vyvod
			help_la >> vyvod
		esac
	else
		uptime | awk '{print $6" "$7" "$8" "$9" "$10}' > vyvod
	fi
	;;

	-k | --kill)
kill -L | sed 's/\t/\n/g' |awk -F ")" '{print $2}' | head -n +62 > sig_name
kill -L | sed 's/\t/\n/g' |awk -F ")" '{print $1}' | sed 's/ //g' | head -n +62 > sig_num
	arg=`echo "$2" | awk -F- '{print $2}'`
ps -aux | awk  '{print $2}' | tail -n +2 > pids
func_sovp () {
	sovp1=`cat sig_num | grep "^$1$"`
	sovp2=`cat sig_name | grep "^ $1$"`
	sovp4=`cat sig_name | sed 's/SIG//g' |  grep "^ $1$"`
	sovp3=`cat pids | grep "^$2$"`
	if [ "$sovp1" == "" ] && [ "$sovp2" == "" ] && [ "$sovp4" == "" ] && [ "$1" != "" ]; then
		echo "@@@@@@@@@@@@@@@@@"
		echo "Неверно введен параметр!"
		echo "@@@@@@@@@@@@@@@@@"
		help_kill
	else
		if [ $sovp1 ] || [ $sovp2 ] || [ $sovp4 ];then
			if [ $2 ];then
				if [ $sovp3 ];then
					kill -s $1 $2
					killing $2 $1
				else
					echo "@@@@@@@@@@@@@@@@@"
					echo "Неверный PID процесса!"
					echo "@@@@@@@@@@@@@@@@@"
					cat pids
				fi
			else
				echo "@@@@@@@@@@@@@@@@@"
				echo "Не введен PID процесса!"
				echo "@@@@@@@@@@@@@@@@@"
				cat pids
			fi
		else
			echo "@@@@@@@@@@@@@@@@@"
			echo "Нет сигнала или он неправильно введен!"
			echo "@@@@@@@@@@@@@@@@@"
			kill -L
		fi
	fi
}
	if [ $2 ] && [ "$2" != "-out" ] && [ "$2" != "--output-file" ]; then
		case $2 in
		-L | --table)
		kill -L > vyvod
		;;
		-l | --list)
sovp_num=`cat sig_num | grep "^$3$"`
sovp_name1=`cat sig_name | grep -i "^ $3$"`
sovp_name2=`cat sig_name | sed 's/SIG//g' |  grep -i "^ $3$"`
funct () {
	cst=`cat sig_num | wc -l`
	let "cst=$cst+1"
	for ((p=1;p<$cst;p++))
	do
		if [ $p -eq 1 ]; then
			((echo " ") && (cat $1 | head -n$p | tail -n +$p) && (cat $2 | head -n$p | tail -n +$p)) | xargs > sig_file
		else
			((echo " ") && (cat $1 | head -n$p | tail -n +$p) && (cat $2 | head -n$p | tail -n +$p)) | xargs >> sig_file
		fi
	done
}
		if [ $3 ]; then
			if [ $sovp_name1 ] || [ $sovp_name2 ]; then
				funct sig_name sig_num
				if [ $sovp_name1 ];then
					cat sig_file | grep  -i "^$3 " | awk '{print $2}' > vyvod
				else
					cat sig_file | sed 's/SIG//g' | grep -i "^$3 " | awk '{print $2}' > vyvod
				fi
			else
				if [ $sovp_num ] ;then
					funct sig_num sig_name
					cat sig_file | grep "^$3 " | awk '{print $2}' > vyvod
				else
					echo "@@@@@@@@@@@@@@@@@" > vyvod
					echo "Неверно введен сигнал!" >> vyvod
					echo "@@@@@@@@@@@@@@@@@" >> vyvod
					kill -L >> vyvod
				fi
			fi
		else
			echo "@@@@@@@@@@@@@@@@@" > vyvod
			echo "Отсутствует сигнал!" >> vyvod
			echo "@@@@@@@@@@@@@@@@@" >> vyvod
			kill -L >> vyvod
		fi
		;;
		-s | --signal)
		func_sovp $3 $4 > vyvod
		;;
		-h | --help)
		help_kill > vyvod
		;;
		-e | --examples)
		exam_kill > vyvod
		;;
		*)
		func_sovp $arg $3 > vyvod
		esac
		if [ -f sig_file ]; then
			rm sig_file
		fi
		if [ -f sig_name ]; then
			rm sig_name
		fi
		if [ -f sig_num ]; then
			rm sig_num
		fi
		if [ -f pids ]; then
			rm pids
		fi
	else
		help_kill > vyvod
	fi
	;;
	-h | --help)
	func_help > vyvod
	;;
	-e | --examples)
	func_examples > vyvod
	;;
	*)
	echo "@@@@@@@@@@@@@@@@@" > vyvod
	echo "Неверно введен параметр!" >> vyvod
	echo "@@@@@@@@@@@@@@@@@" >> vyvod
	func_help >> vyvod
   esac
	if [ -f num_list ];then
		rm num_list
	fi
	if [ -f param_help ];then
		rm param_help
	fi
else
	func_help > vyvod
fi

# запись в лог результатов работы скрипта
# (функция, отрабатывающая отработку параметра сверху)
if [ ${@: -1} == "-out" ] || [ ${@: -1} == "--output-file" ] ;then
	echo "Результат работы скрипта записан в log_script"
	func_out vyvod
	cat vyvod
	rm vyvod
else
	cat vyvod
	rm vyvod
fi
