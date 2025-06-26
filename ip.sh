#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
PLAIN='\033[0m'

red() {
	echo -e "\033[31m\033[01m$1\033[0m"
}

green() {
	echo -e "\033[32m\033[01m$1\033[0m"
}

yellow() {
	echo -e "\033[33m\033[01m$1\033[0m"
}

# Select client CPU architecture
archAffix(){
    case "$(uname -m)" in
        i386 | i686 ) echo '386' ;;
        x86_64 | amd64 ) echo 'amd64' ;;
        armv8 | arm64 | aarch64 ) echo 'arm64' ;;
        s390x ) echo 's390x' ;;
        * ) red "Unsupported CPU architecture!" && exit 1 ;;
    esac
}

endpointyx() {
    wget https://raw.githubusercontent.com/TheyCallMeSecond/WARP-Endpoint-IP/main/files/warp-linux-$(archAffix) -O warp
    ulimit -n 102400
    chmod +x warp && ./warp >/dev/null 2>&1

    green "🌍 Displaying filtered and randomized IPs with location info..."

    # خروجی فیلتر شده رو به صورت موقت در فایل می‌نویسیم
    tail -n +2 result.csv | awk -F, '$3!="timeout ms"' | while IFS=, read -r ipport loss delay; do
        ip="${ipport%%:*}"
        loss_clean=$(echo "$loss" | tr -d '%')
        delay_clean=$(echo "$delay" | awk '{print $1}')

        # فیلتر: فقط پکت‌لاس صفر و تأخیر کمتر از 50
        if [[ "$loss_clean" == "0.00" && "$delay_clean" -lt 50 ]]; then
            echo "$ipport,$loss,$delay" >> /tmp/filtered_results.txt
        fi
    done

    # اگر چیزی پیدا نشده بود
    if [[ ! -s /tmp/filtered_results.txt ]]; then
        red "❌ No suitable IPs found (check loss and delay thresholds)"
        rm -f warp ip.txt /tmp/filtered_results.txt
        return
    fi

    # نمایش رندوم‌شده آی‌پی‌ها با لوکیشن
    shuf /tmp/filtered_results.txt | while IFS=, read -r ipport loss delay; do
        ip="${ipport%%:*}"
        country=$(curl -s --max-time 3 "http://ip-api.com/json/$ip" | jq -r '.countryCode')
        [[ "$country" == "null" || -z "$country" ]] && country="??"
        echo -e "🌐 [$country] $ipport (Loss: $loss, Delay: $delay)"
    done

    echo ""
    yellow "💡 Use the selected IPs to replace engage.cloudflareclient.com:2408 in your config."

    rm -f warp ip.txt /tmp/filtered_results.txt
}


endpoint4() {

	# Generate a list of preferred WARP IPv4 Endpoint IP segments
	n=0
	iplist=100
	while true; do
		temp[$n]=$(echo 162.159.192.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 162.159.193.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 162.159.195.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 162.159.204.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 188.114.96.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 188.114.97.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 188.114.98.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 188.114.99.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
	done
	while true; do
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 162.159.192.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 162.159.193.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 162.159.195.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 162.159.204.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 188.114.96.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 188.114.97.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 188.114.98.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 188.114.99.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
	done

	# Put the generated IP segment list into ip.txt and wait for program optimization
	echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u >ip.txt

	# Start the preferred program
	endpointyx
}

endpoint6() {
	# Generate a list of preferred WARP IPv6 Endpoint IP segments
	n=0
	iplist=100
	while true; do
		temp[$n]=$(echo [2606:4700:d0::$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2)))])
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo [2606:4700:d1::$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2)))])
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
	done
	while true; do
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo [2606:4700:d0::$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2)))])
			n=$(($n + 1))
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo [2606:4700:d1::$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2)))])
			n=$(($n + 1))
		fi
	done

	# Put the generated IP segment list into ip.txt and wait for program optimization
	echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u >ip.txt

	# Start the preferred program
	endpointyx
}

menu() {
	clear
	echo "########################################################"
	echo -e "#     ${RED}WARP Endpoint IP one-click optimization script${PLAIN}   #"
	echo -e "# ${GREEN}author${PLAIN}: Misaka                                       #"
	echo -e "# ${GREEN}blog${PLAIN}: https://blog.misaka.rest                       #"
	echo -e "# ${GREEN}GitHub project${PLAIN}: https://github.com/Misaka-blog       #"
	echo -e "# ${GREEN}GitLab project${PLAIN}: https://gitlab.com/Misaka-blog       #"
	echo -e "# ${GREEN}Telegram channel${PLAIN}: https://t.me/misakanocchannel      #"
	echo -e "# ${GREEN}Telegram group${PLAIN}: https://t.me/misakanoc               #"
	echo -e "# ${GREEN}YouTube channel${PLAIN}: https://www.youtube.com/@misaka-blog#"
	echo -e "# ${GREEN}TRANSLATED BY: ${PLAIN}: @theTCS_                            #"
	echo "########################################################"
	echo ""
	echo -e " ${GREEN}1.${PLAIN} WARP IPv4 Endpoint IP Preferred ${YELLOW}(default)${PLAIN}"
	echo -e " ${GREEN}2.${PLAIN} WARP IPv6 Endpoint IP Preferred"
	echo " -------------"
	echo -e " ${GREEN}0.${PLAIN} Exit script"
	echo ""
	read -rp "Please enter options [0-2]: " menuInput
	case $menuInput in
	2) endpoint6 ;;
	0) exit 1 ;;
	*) endpoint4 ;;
	esac
}

menu
