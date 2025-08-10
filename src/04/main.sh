#!/usr/bin/env bash

# Массивы ANSI-кодов
bg_colors=("" "\033[107m" "\033[101m" "\033[102m" "\033[104m" "\033[105m" "\033[40m")
fg_colors=("" "\033[97m"  "\033[91m"  "\033[92m"  "\033[94m"  "\033[95m"  "\033[30m")
reset="\033[0m"

# Цвета по умолчанию
DEFAULT_COL1_BG=6
DEFAULT_COL1_FG=1
DEFAULT_COL2_BG=3
DEFAULT_COL2_FG=4

# Загружаем конфиг, если он есть
CONFIG_FILE="config.conf"
[[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

# Присваиваем значения, с дефолтоми
bg_name=${column1_background:-$DEFAULT_COL1_BG}
fg_name=${column1_font_color:-$DEFAULT_COL1_FG}
bg_value=${column2_background:-$DEFAULT_COL2_BG}
fg_value=${column2_font_color:-$DEFAULT_COL2_FG}

for var in bg_name fg_name bg_value fg_value; do
    val=${!var}
    if ! [[ "$val" =~ ^[1-6]$ ]]; then
        echo "Ошибка: значение переменной '$var' должно быть числом от 1 до 6 а не '$val'."
        exit 1
    fi
done

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

