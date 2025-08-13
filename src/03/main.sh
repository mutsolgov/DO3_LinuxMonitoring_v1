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

