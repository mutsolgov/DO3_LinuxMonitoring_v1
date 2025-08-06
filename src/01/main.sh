#!/usr/bin/env bash

# 1. Подключаем вспомогательные функции:
source "$(dirname "$0")/functions.sh"

# 2. Проверка колличества аргументов:
check_param_count "$@"

param="$1"

# 3. Проверяем, не число ли это:
if is_integer "$param"; then
	echo "Невалидный ввод: ожидался текст, но получено число." >&2
	exit 2
fi

# 4. Если все ок - выводим параметр:
echo "Вы ввели: $param"