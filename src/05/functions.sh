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

