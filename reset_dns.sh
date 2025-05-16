#!/bin/sh
echo "Content-type: text/plain"
echo ""

# Меняем строку option dns_server на 8.8.8.8
sed -i "s/^\(.*option dns_server \).*/\1'8.8.8.8'/" /etc/config/podkop

# Перезапускаем сервис podkop
/etc/init.d/podkop restart

echo "DNS успешно изменён на 8.8.8.8 и podkop перезапущен"

