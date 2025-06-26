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
    wget https://raw.githubusercontent.com/Amirchelios/WARP-Endpoint-IP/main/files/warp-linux-$(archAffix) -O warp
    ulimit -n 102400
    chmod +x warp && ./warp >/dev/null 2>&1

    target_countries=("US" "DE" "GB" "NL" "AE")
    declare -A selected

    green "🔍 Selecting best IPs from desired countries..."
    
    tail -n +2 result.csv | awk -F, '$3!="timeout ms"' | sort -t, -nk2 -nk3 | uniq | while IFS=, read -r ipport loss delay; do
        ip="${ipport%%:*}"  # ← جدا کردن IP از PORT

        echo "🔎 Testing IP: $ip..."
        country=$(curl -s --max-time 3 "http://ip-api.com/json/$ip" | jq -r '.countryCode')

        if [[ -z "$country" || "$country" == "null" ]]; then
            echo "  ↪ ⚠️ Failed to get country for $ip"
            continue
        fi

        echo "  ↪ 📍 $ip is from $country"
        if [[ " ${target_countries[*]} " == *" $country "* ]] && [[ -z "${selected[$country]}" ]]; then
            selected[$country]="$ip"
            echo -e "✅ [$country] $ip (Loss: $loss, Delay: $delay)"
        fi

        if [[ ${#selected[@]} -eq ${#target_countries[@]} ]]; then
            break
        fi
    done

    echo ""
    yellow "💡 You can replace engage.cloudflareclient.com:2408 with one of the above IPs in your WireGuard config."

    rm -f warp ip.txt
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
