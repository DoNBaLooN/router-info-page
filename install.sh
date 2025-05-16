#!/bin/sh

REPO_URL="https://raw.githubusercontent.com/DoNBaLooN/router-info-page/main"  # Укажи свой URL
WWW_DIR="/www"

echo "Загружаем файлы с GitHub..."
wget -O "$WWW_DIR/ip.html" "$REPO_URL/ip.html"
wget -O "$WWW_DIR/wanip.sh" "$REPO_URL/wanip.sh"
wget -O "$WWW_DIR/reset_dns.sh" "$REPO_URL/reset_dns.sh"

echo "Делаем wanip.sh исполняемым..."
chmod +x "$WWW_DIR/wanip.sh"
chmod +x "$WWW_DIR/reset_dns.sh"

echo "Проверяем настройку uhttpd на поддержку .sh..."
if ! uci get uhttpd.main.interpreter 2>/dev/null | grep -q "/bin/sh"; then
    echo "➕ Добавляем поддержку .sh в uhttpd..."
    uci add_list uhttpd.main.interpreter='.sh=/bin/sh'
    uci commit uhttpd
else
    echo "✅ Поддержка .sh уже включена."
fi

echo "Перезапуск uhttpd..."
/etc/init.d/uhttpd restart

echo "✅ Установка завершена. Откройте в браузере: http://<router_ip>/ip.html"
