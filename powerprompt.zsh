build_prompt(){
    red=`tput setaf 160`
    dark_red=`tput setaf 124`
    green=`tput setaf 34`
    yellow=`tput setaf 220`
    blue=`tput setaf 21`
    magenta=`tput setaf 56`
    purple=`tput setaf 129`
    grey=`tput setaf 11`
    light_grey=`tput setaf 238`
    sea=`tput setaf 33`
    skin=`tput setaf 203`
    reset=`tput sgr0`
    bold=`tput bold`
    underline=`tput smul`
    
    local_ip=`ip address | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
    #global_ip=`wget http://ipecho.net/plain -O - -q ; echo`
    network=`iwconfig $iface | grep ESSID | awk -F: '{print $2}' 2>/dev/null` 
    ip_gateway=`ip route show 0.0.0.0/0 dev $iface | cut -d\  -f3`
    net=$(echo $network|sed 's/"//g'|xargs) 
    net_quality=$(cat /proc/net/wireless|tail -1|awk '{printf $3}'|sed 's/.$//')
    
    if [ "$net_quality" -ge 45 ] && [ "$net_quality" -le 70 ]; then
        q="$green       $reset"
    elif [ "$net_quality" -ge 30 ] && [ "$net_quality" -le 45 ]; then
        q="$green      $reset $light_grey   $reset"
    elif [ "$net_quality" -ge 30 ] && [ "$net_quality" -le 45 ]; then
        q="$green     $reset $light_grey   $reset"
    elif [ "$net_quality" -ge 15 ] && [ "$net_quality" -le 30 ]; then
        q="$green    $reset $light_grey    $reset"
    elif [ "$net_quality" -ge 0 ] && [ "$net_quality" -le 15 ]; then
        q="$green   $reset $light_grey     $reset"
    fi
    
    time=$(date +"%H:%M")
    cpu=$(mpstat|tail -1|awk '{printf $3}')
    cpu=${cpu:0:2}
    disk=$(df -h /dev/sda6|tail -1|awk '{printf $4}')
    jobs_n=$(jobs|wc -l)
    
    if [ "$(aa-enabled)" = "Yes" ]; then
        shield="$green enabled$reset"
    else
        shield="$red disabled$reset"
    fi 
    
    bat_level=$(acpi|head -1|sed 's/.$//'| awk '{printf $4}')
    if [ "$bat_level" -ge 75 ] && [ "$bat_level" -le 100 ]; then
        bat="$green  $bat_level $reset"
    elif [ "$bat_level" -ge 50 ] && [ "$bat_level" -le 75 ]; then
        bat="$green  $bat_level $reset"
    elif [ "$bat_level" -ge 25 ] && [ "$bat_level" -le 50 ]; then
        bat="$yellow  $bat_level $reset"
    elif [ "$bat_level" -ge 0 ] && [ "$bat_level" -le 25 ]; then
        bat="$red $bat_level $reset"
    fi
    
    if [[ "$(acpi -a)" =~ .*off.* ]]; then
        charge="$light_grey$reset"
    else
        charge="$yellow$reset"
    fi
    
    s="$grey $reset"
    final="$grey$reset"
    
    NEWLINE=$'\n'
    
    export PROMPT="$red  $local_ip$reset $s $blue  $ip_gateway$reset $s $green  $net$reset$q$reset$s $magenta $time$reset $s $shield$s $dark_red $disk$reset $s $bat$charge $s $sea $cpu$reset $s $yellow $(whoami)$reset $s $skin $jobs_n$reset $s $purple  $(pwd)$reset  ${NEWLINE} $final "
}
precmd_functions+=build_prompt
build_prompt
