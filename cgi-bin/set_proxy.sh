#!/bin/sh
echo "Content-Type: text/plain"
echo

# Извлекаем и декодируем параметр link
raw="${QUERY_STRING#*link=}"
urldecode(){
  local data="$1"
  data="${data//+/ }"
  printf '%b' "${data//%/\\x}"
}
link="$(urldecode "$raw")"

# Меняем UCI, коммитим
uci set podkop.main.proxy_string="$link"
uci commit podkop

# Перезапускаем podkop, но скрываем весь вывод
/etc/init.d/podkop restart >/dev/null 2>&1

# Возвращаем только OK
echo "OK"

