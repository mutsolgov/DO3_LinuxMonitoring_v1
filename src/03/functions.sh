#!/usr/bin/env bash

# 1. Получаем имя хоста
get_hostname() {
    hostname
}

# 2. Получаем временную зону: Continent/City и смещение UTC
get_timezone() {
    local tz_name
    tz_name=$(cat /etc/timezone 2>/dev/null) || tz_name=$(timedatectl show -p Timezone --value)
    local utc_offset
    utc_offset=$(date +%:z)
    echo "$tz_name UTC $utc_offset"
}

# 3. Получаем текущего пользователя
get_user() {
    whoami
}

# 4. Тип и версия OC
get_os() {
    if command -v lsb_release >/dev/null; then
        lsb_release -ds
    else
        grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"'
    fi
}

# 5. Текущее дата-время
get_date() {
    date +"%d %B %Y %T"
}

# 6. Время работы системы
get_uptime() {
    uptime -p
}

# 7. Время работы в секундах
get_uptime_sec() {
    cat /proc/uptime | awk '{print int($1)}'
}

