#!/bin/sh
echo "Content-Type: text/plain; charset=utf-8"
echo ""

# Получаем WAN IP
. /lib/functions/network.sh
network_get_ipaddr wan_ip wan

# Получаем ZeroTier IP
zt_iface="$(ip -o link show | awk -F': ' '/: zt/{print $2; exit}')"
zt_ip="$(ip -4 addr show dev "$zt_iface" | awk '/inet / {print $2}' | cut -d/ -f1)"

# Проверяем VPN через showip.net, смотрим только первый октет
vpn_ip="$(nslookup showip.net 127.0.0.1 2>/dev/null | awk '/^Address: /{ print $2; exit }')"
first_octet="${vpn_ip%%.*}"
if [ "$first_octet" = "198" ]; then
  vpn_status="enabled"
else
  vpn_status="disabled"
fi

# Получаем статус DNS
dns_json="$(podkop check_dns_available 2>/dev/null)"
dns_type="$(echo "$dns_json" | jsonfilter -e '@.dns_type')"
dns_server="$(echo "$dns_json" | jsonfilter -e '@.dns_server')"
dns_status="$(echo "$dns_json" | jsonfilter -e '@.status')"
local_dns_status="$(echo "$dns_json" | jsonfilter -e '@.local_dns_status')"

# Получаем текущую страну VPN из proxy_string
# Берём ссылку из UCI
link="$(uci get podkop.main.proxy_string 2>/dev/null)"
# Отрезаем всё до символа '#'
fragment="${link#*#}"
# Функция для URL-декодирования
urldecode(){
  local data="$1"
  data="${data//+/ }"                     # + -> пробел, если встретится
  # каждый %XX -> \xXX, printf '%b' сделает из этого байты
  printf '%b' "${data//%/\\x}"
}
# Декодируем
current_country="$(urldecode "$fragment")"

# Вывод
echo "WAN IP: $wan_ip"
echo "ZT IP: $zt_ip"
echo "VPN Status: $vpn_status"
echo "DNS Type: $dns_type"
echo "DNS Server: $dns_server"
echo "DNS Status: $dns_status"
echo "Local DNS: $local_dns_status"
echo "Country: $current_country"
