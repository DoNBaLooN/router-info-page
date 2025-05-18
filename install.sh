#!/bin/sh

REPO_URL="https://raw.githubusercontent.com/DoNBaLooN/router-info-page/main"  # Укажи свой URL
WWW_DIR="/www"

# Создаём необходимые каталоги
echo "Создаём каталоги $WWW_DIR/country и $WWW_DIR/cgi-bin..."
mkdir -p "$WWW_DIR/country"
mkdir -p "$WWW_DIR/cgi-bin"

# Загружаем основные файлы в WWW_DIR
echo "Загружаем файлы в $WWW_DIR..."
wget -O "$WWW_DIR/ip.html"         "$REPO_URL/ip.html"
wget -O "$WWW_DIR/countries.html" "$REPO_URL/countries.html"
wget -O "$WWW_DIR/wanip.sh"       "$REPO_URL/wanip.sh"
wget -O "$WWW_DIR/set_time.sh"    "$REPO_URL/set_time.sh"
wget -O "$WWW_DIR/reset_dns.sh"   "$REPO_URL/reset_dns.sh"
wget -O "$WWW_DIR/get_time.sh"    "$REPO_URL/get_time.sh"

# Загружаем файл подписок
echo "Загружаем subscriptions.txt в $WWW_DIR/country..."
wget -O "$WWW_DIR/country/subscriptions.txt" "$REPO_URL/subscriptions.txt"

# Загружаем CGI-скрипты
echo "Загружаем CGI-скрипты в $WWW_DIR/cgi-bin..."
wget -O "$WWW_DIR/cgi-bin/upload_subscriptions.sh" "$REPO_URL/upload_subscriptions.sh"
wget -O "$WWW_DIR/cgi-bin/set_proxy.sh"           "$REPO_URL/set_proxy.sh"
wget -O "$WWW_DIR/cgi-bin/countries.sh"           "$REPO_URL/countries.sh"

# Делаем все скрипты исполняемыми
echo "Делаем скрипты исполняемыми..."
chmod +x "$WWW_DIR"/*.sh
chmod +x "$WWW_DIR/cgi-bin"/*.sh

# Проверяем настройку uhttpd на поддержку .sh
echo "Проверяем поддержку .sh в uhttpd..."
if ! uci get uhttpd.main.interpreter 2>/dev/null | grep -q "/bin/sh"; then
    echo "➕ Добавляем поддержку .sh в uhttpd..."
    uci add_list uhttpd.main.interpreter='.sh=/bin/sh'
    uci commit uhttpd
else
    echo "✅ Поддержка .sh уже включена."
fi

# Перезапуск uhttpd
echo "Перезапуск uhttpd..."
/etc/init.d/uhttpd restart

echo "✅ Установка завершена. Откройте в браузере: http://<router_ip>/ip.html"
