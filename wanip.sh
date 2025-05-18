#!/bin/sh
echo "Content-Type: text/plain; charset=utf-8"
echo ""

# �������� WAN IP
. /lib/functions/network.sh
network_get_ipaddr wan_ip wan

# �������� ZeroTier IP
zt_iface="$(ip -o link show | awk -F': ' '/: zt/{print $2; exit}')"
zt_ip="$(ip -4 addr show dev "$zt_iface" | awk '/inet / {print $2}' | cut -d/ -f1)"

# ��������� VPN ����� showip.net, ������� ������ ������ �����
vpn_ip="$(nslookup showip.net 127.0.0.1 2>/dev/null | awk '/^Address: /{ print $2; exit }')"
first_octet="${vpn_ip%%.*}"
if [ "$first_octet" = "198" ]; then
  vpn_status="enabled"
else
  vpn_status="disabled"
fi

# �������� ������ DNS
dns_json="$(podkop check_dns_available 2>/dev/null)"
dns_type="$(echo "$dns_json" | jsonfilter -e '@.dns_type')"
dns_server="$(echo "$dns_json" | jsonfilter -e '@.dns_server')"
dns_status="$(echo "$dns_json" | jsonfilter -e '@.status')"
local_dns_status="$(echo "$dns_json" | jsonfilter -e '@.local_dns_status')"

# �������� ������� ������ VPN �� proxy_string
# ���� ������ �� UCI
link="$(uci get podkop.main.proxy_string 2>/dev/null)"
# �������� �� �� ������� '#'
fragment="${link#*#}"
# ������� ��� URL-�������������
urldecode(){
  local data="$1"
  data="${data//+/ }"                     # + -> ������, ���� ����������
  # ������ %XX -> \xXX, printf '%b' ������� �� ����� �����
  printf '%b' "${data//%/\\x}"
}
# ����������
current_country="$(urldecode "$fragment")"

# �����
echo "WAN IP: $wan_ip"
echo "ZT IP: $zt_ip"
echo "VPN Status: $vpn_status"
echo "DNS Type: $dns_type"
echo "DNS Server: $dns_server"
echo "DNS Status: $dns_status"
echo "Local DNS: $local_dns_status"
echo "Country: $current_country"
