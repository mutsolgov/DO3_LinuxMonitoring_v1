#!/usr/bin/env bash

# Проверка аргументов
if [[ $# -ne 4 ]]; then
    echo "Ошибка: требуется ровно 4 параметра. Пример использования: $0 1 3 4 5"
    exit 1
fi

# Проверка, что параметры от 1 до 6
for i in "$@"; do
    if ! [[ "$i" =~ ^[1-6]$ ]]; then
        echo "Ошибка: параметры должны быть числами от 1 до 6."
        exit 1
    fi
done

bg_name=$1
fg_name=$2
bg_value=$3
fg_value=$4

# Проверка на совпадение цветов и фона
if [[ "$bg_name" -eq "$fg_name" ]]; then
    echo "Ошибка: Цвет текста и фона названий совпадают."
    echo "Повторите вызов скрипта с разными параметрами."
    exit 2
fi

if [[ "$bg_value" -eq "$fg_value" ]]; then
    echo "Ошибка: Цвет текста и фона значений совпадают."
    echo "Повторите вызов скрипта с разными параметрами."
    exit 2
fi

# Массивы ANSI-кодов
bg_colors=("" "\033[107m" "\033[101m" "\033[102m" "\033[104m" "\033[105m" "\033[40m")
fg_colors=("" "\033[97m"  "\033[91m"  "\033[92m"  "\033[94m"  "\033[95m"  "\033[30m")
reset="\033[0m"

# Функция для вывода с цветами
print_colored_line() {
    local key="$1"
    local value="$2"
    echo -e "${bg_colors[$bg_name]}${fg_colors[$fg_name]} $key ${reset} = ${bg_colors[$bg_value]}${fg_colors[$fg_value]} $value ${reset}"
}

# Получаем данные
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
# cat <<EOF
print_colored_line "HOSTNAME" "$HOSTNAME"
print_colored_line "TIMEZONE" "$TIMEZONE"
print_colored_line "USER" "$USER"
print_colored_line "OS" "$OS"
print_colored_line "DATE" "$DATE"
print_colored_line "UPTIME" "$UPTIME"
print_colored_line "UPTIME_SEC" "$UPTIME_SEC"
print_colored_line "IP" "$IP"
print_colored_line "MASK" "$MASK"
print_colored_line "GATEWAY" "$GATEWAY"
print_colored_line "RAM_TOTAL" "${RAM_TOTAL} GB"
print_colored_line "RAM_USED" "${RAM_USED} GB"
print_colored_line "RAM_FREE" "${RAM_FREE} GB"
print_colored_line "SPACE_ROOT" "${SPACE_ROOT} MB"
print_colored_line "SPACE_ROOT_USED" "${SPACE_ROOT_USED} MB"
print_colored_line "SPACE_ROOT_FREE" "${SPACE_ROOT_FREE} MB"
