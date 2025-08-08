#!/usr/bin/env bash

source "$(dirname "$0")/functions.sh"

HOSTNAME=$(get_hostname)
TIMEZONE=$(get_timezone)
USER=$(get_user)
OS=$(get_os)
DATE=$(get_date)
UPTIME=$(get_uptime)
UPTIME_SEC=$(get_uptime_sec)

read IP_RAW MASK_RAW < <(get_ip_and_mask)
IP=$IP_RAW

# берём маску префикса из /proc/net/fib_trie
mask=$(ip -o -f inet addr show scope global | awk -v ip="$IP_RAW" '
  $4 ~ ip"/" { split($4, a, "/"); prefix=a[2];
    for(i=1; i<=4; i++) oct[i] = and(255, rshift(0xFFFFFFFF, (i-1)*8 + (32-prefix)));
    printf "%d.%d.%d.%d\n", oct[1],oct[2],oct[3],oct[4];
    exit }
')
[[ -z $mask ]] && MASK=$MASK_RAW || MASK=$mask


GATEWAY=$(get_gateway)

read RAM_TOTAL RAM_USED RAM_FREE _ < <(get_ram)

read SPACE_ROOT SPACE_ROOT_USED SPACE_ROOT_FREE < <(get_root_space)

# Выводим в формате "KEY = VALUE":
cat <<EOF
HOSTNAME = $HOSTNAME
TIMEZONE = $TIMEZONE
USER = $USER
OS = $OS
DATE = $DATE
UPTIME = $UPTIME
UPTIME_SEC = $UPTIME_SEC
IP = $IP
MASK = $MASK
GATEWAY = $GATEWAY
RAM_TOTAL = ${RAM_TOTAL} GB
RAM_USED = ${RAM_USED} GB
RAM_FREE = ${RAM_FREE} GB
SPACE_ROOT = ${SPACE_ROOT} MB
SPACE_ROOT_USED = ${SPACE_ROOT_USED} MB
SPACE_ROOT_FREE = ${SPACE_ROOT_FREE} MB
EOF

# Предложение сохранить в файл
read -rp "Сохранить результаты в файл? [Y/N]: " answer
case $answer in
    [Yy])
    timestamp=$(date +"%d_%m_%y_%H_%M_%S")
    filename="${timestamp}.status"
    cat <<EOF >"$filename"
HOSTNAME = $HOSTNAME
TIMEZONE = $TIMEZONE
USER = $USER
OS = $OS
DATE = $DATE
UPTIME = $UPTIME
UPTIME_SEC = $UPTIME_SEC
IP = $IP
MASK = $MASK
GATEWAY = $GATEWAY
RAM_TOTAL = ${RAM_TOTAL} GB
RAM_USED = ${RAM_USED} GB
RAM_FREE = ${RAM_FREE} GB
SPACE_ROOT = ${SPACE_ROOT} MB
SPACE_ROOT_USED = ${SPACE_ROOT_USED} MB
SPACE_ROOT_FREE = ${SPACE_ROOT_FREE} MB
EOF
    echo "Данные сохранены в файл: $filename"
    ;;
    *)
    echo "Данные не сохранены."
    ;;
esac