#!/bin/sh

REPO_RAW="https://raw.githubusercontent.com/DoNBaLooN/router-info-page/main"
WWW_DIR="/www"

# Создаём необходимые каталоги
echo "Создаём каталоги $WWW_DIR/country и $WWW_DIR/cgi-bin..."
mkdir -p "$WWW_DIR/country"

# Загружаем основные файлы в WWW_DIR
echo "Загружаем файлы в $WWW_DIR..."
wget -O "$WWW_DIR/ip.html"           "$REPO_RAW/ip.html"
wget -O "$WWW_DIR/countries.html"   "$REPO_RAW/countries.html"
wget -O "$WWW_DIR/wanip.sh"         "$REPO_RAW/wanip.sh"
wget -O "$WWW_DIR/set_time.sh"      "$REPO_RAW/set_time.sh"
wget -O "$WWW_DIR/reset_dns.sh"     "$REPO_RAW/reset_dns.sh"
wget -O "$WWW_DIR/get_time.sh"      "$REPO_RAW/get_time.sh"

# Загружаем файл подписок из папки country
echo "Загружаем subscriptions.txt в $WWW_DIR/country..."
wget -O "$WWW_DIR/country/subscriptions.txt" \
     "$REPO_RAW/country/subscriptions.txt"

# Загружаем CGI-скрипты из папки cgi-bin
echo "Загружаем CGI-скрипты в $WWW_DIR/cgi-bin..."
wget -O "$WWW_DIR/cgi-bin/upload_subscriptions.sh" \
     "$REPO_RAW/cgi-bin/upload_subscriptions.sh"
wget -O "$WWW_DIR/cgi-bin/set_proxy.sh" \
     "$REPO_RAW/cgi-bin/set_proxy.sh"
wget -O "$WWW_DIR/cgi-bin/countries.sh" \
     "$REPO_RAW/cgi-bin/countries.sh"

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
