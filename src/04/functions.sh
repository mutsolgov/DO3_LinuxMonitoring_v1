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

# 8. Первый непустой IPV4-адрес и маска
get_ip_and_mask() {
    ip -4 addr show scope global | awk '/inet/ {
    split($2,a,"/");
    print a[1], "/" a[2];
    exit
    }'
}

# 9. Шлюз по умолчанию
get_gateway() {
    ip route | awk '/default/ {print $3; exit}'
}

# 10. Память: всего, занято, свободно
get_ram() {
    local total used free
    read total used free _ < <(free --mega | awk '/Mem:/ {printf "%.3f %.3f %.3f\n", $2/1024, $3/1024, $4/1024}')
    echo "$total" "$used" "$free"
}

# 11. Пространство в корне: всего, занято, свободно
get_root_space() {
    local total used free
    read total used free _ < <(df --output=size,used,avail --block-size=1M / | tail -n1 | awk '{printf "%.2f %.2f %.2f\n", $1, $2, $3}')
    echo "$total" "$used" "$free"
}
