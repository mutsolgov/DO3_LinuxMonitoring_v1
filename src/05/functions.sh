#!/usr/bin/env bash

# 1) Колличество папок
get_total_dirs() {
    find "$1" -type d | wc -l
}

# 2) Топ-N папок по размеру в формате "path, size"
get_top_dirs() {
    local dir=$1 count=$2
    find "$dir" -type d -print0 \
        | xargs -0 du -sb 2>/dev/null \
        | sort -nrk1,1 \
        | head -n"$count" \
        | awk '{print $2", "$1}'
}

# 3) Общее число файлов
get_total_files() {
    find "$1" -type f | wc -l
}

# 4) Подсчет по типам
get_count_by_ext() {
    local dir=$1 ext_pattern=$2
    find "$dir" -type f -iname "*.$ext_pattern" | wc -l
}
get_count_exe() {
    find "$1" -type f -executable | wc -l
}
get_count_links() {
    find "$1" -type l | wc -l 
}
get_count_text() {
    local dir="$1"
    find "$dir" -type f -print0 \
        | xargs -0 -P "$(nproc)" grep -IPl . \
        | wc -l
}

# 5) Топ-N файлов по размеру: возвращает "path, size, ext"
get_top_files() {
    local dir=$1 count=$2
    find "$dir" -type f -printf "%s %p\n" \
        | sort -nrk1,1 \
        | head -n"$count" \
        | while read -r size path; do
            ext="${path##*.}"
            echo "$path,$size,$ext"
        done
}

