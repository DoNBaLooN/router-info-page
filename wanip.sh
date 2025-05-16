#!/bin/sh
echo "Content-Type: text/plain; charset=utf-8"
echo ""


# Получаем WAN IP
. /lib/functions/network.sh
network_get_ipaddr wan_ip wan

# Получаем ZeroTier IP
zt_iface="$(ip -o link show | awk -F': ' '/: zt/{print $2; exit}')"
zt_ip="$(ip -4 addr show dev "$zt_iface" | awk '/inet / {print $2}' | cut -d/ -f1)"

# Получаем статус DNS
dns_json="$(podkop check_dns_available 2>/dev/null)"
dns_type="$(echo "$dns_json" | jsonfilter -e '@.dns_type')"
dns_server="$(echo "$dns_json" | jsonfilter -e '@.dns_server')"
dns_status="$(echo "$dns_json" | jsonfilter -e '@.status')"
local_dns_status="$(echo "$dns_json" | jsonfilter -e '@.local_dns_status')"

# Вывод
echo "WAN IP: $wan_ip"
echo "ZT IP: $zt_ip"
echo "DNS Type: $dns_type"
echo "DNS Server: $dns_server"
echo "DNS Status: $dns_status"
echo "Local DNS: $local_dns_status"
