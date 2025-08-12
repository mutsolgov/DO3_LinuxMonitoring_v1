#!/usr/bin/env bash

# 0. Проверка
if [[ $# -ne 1 ]]; then
    cat <<EOF 
Ошибка: ожидается равно один аргумент - путь к директории:
Использование: $0 DIRECTORY/
EOF
    exit 1
fi
DIR="$1"
[[ "${DIR: -1}" != "/" ]] && { echo "Ошибка: путь '$DIR' должен заканчиваться символом '/'."; exit 1; }
[[ ! -d "$DIR" ]] && { echo "Ошибка: '$DIR' не является директорией или не существует."; exit 1; }

# 1. Время старта
START=$(date +%s.%N)

# 2. Подключаем функции
source "$(dirname "$0")/functions.sh"

# 3. Собираем метрики
total_dirs=$(get_total_dirs "$DIR")
top5=$(get_top_dirs "$DIR" 5)
total_files=$(get_total_files "$DIR")

conf_files=$(get_count_by_ext "$DIR" "conf")
log_files=$(get_count_by_ext "$DIR" "log")
arch_files=$(find "$DIR" -type f \( -iname '*.zip' -o -iname '*.gz' -o -iname '*.bz2' -o -iname '*.7z' \) | wc -l)
links=$(get_count_links "$DIR")
exe_files=$(get_count_exe "$DIR")
text_files=$(get_count_text "$DIR")

top10_files=$(get_top_files "$DIR" 10)
top10_exe=$(get_top_exe_files "$DIR" 10)

# 4. Время окончания
END=$(date +%s.%N)
elapsed=$(echo "$END - $START" | bc)

# 5. Выводим результат
echo "Total number of folders (including all nested ones) = $total_dirs"

echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
i=1
while IFS=',' read -r path size; do
    echo "$i - $path, $(to_human "$size")"
    ((i++))
done <<<"$top5"
echo "etc up to 5"

echo "Total number of files= $total_files"
echo "Number of:"
echo "Configuration files (with the .conf extension) = $conf_files"
echo "Text files = $text_files"
echo "Executable files = $exe_files"
echo "Log files (with the extension .log) = $log_files"
echo "Archive files = $arch_files"
echo "Symbolic links = $links"

