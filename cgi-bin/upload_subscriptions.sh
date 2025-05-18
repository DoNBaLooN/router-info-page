#!/bin/sh
# upload_subscriptions.sh — CGI для обработки вставленного содержимого subscriptions.txt

# Устанавливаем локаль для корректной обработки UTF-8
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Пути к файлу и резервной копии
TARGET="/www/country/subscriptions.txt"
BACKUP="${TARGET}.bak"

# HTTP-заголовок с кодировкой UTF-8
echo "Content-Type: text/html; charset=UTF-8"
echo

# Чтение POST-данных по CONTENT_LENGTH
if [ -n "$CONTENT_LENGTH" ]; then
  read -r -n "$CONTENT_LENGTH" POST_DATA
else
  POST_DATA=""
fi

# Замена '+' на пробел
POST_DATA=$(printf '%s' "$POST_DATA" | sed 's/+/ /g')

# Извлечение URL-кодированного содержимого после 'content='
ENC_CONTENT="${POST_DATA#content=}"

# Функция декодирования %XX
percent_decode() {
  # Переводим каждое %%XX в \xXX, затем printf '%b' для превращения в символы
  printf '%b' "${1//%/\\x}"
}

# Декодируем строку
DECODED=$(percent_decode "$ENC_CONTENT")

# Запись декодированного текста в временный файл
TMP_CONTENT=$(mktemp /tmp/content.XXXXXX)
printf '%s' "$DECODED" > "$TMP_CONTENT"

# Проверка наличия 'Sweden' (без учета регистра)
if ! grep -qi "Sweden" "$TMP_CONTENT"; then
  echo "<html><head><meta charset=\"UTF-8\"></head><body>"
  echo "<h1 style='color: red;'>Ошибка: не правильный формат</h1>"
  echo "<p><a href='/ip.html'>На главную страницу</a></p>"
  echo "</body></html>"
  rm -f "$TMP_CONTENT"
  exit 0
fi

# Резервная копия старого файла
# [ -f "$TARGET" ] && mv "$TARGET" "$BACKUP"

# Сохранение нового контента
if mv "$TMP_CONTENT" "$TARGET"; then
  echo "<html><head><meta charset=\"UTF-8\"></head><body>"
  echo "<h1 style='color: green;'>Успешно отправлено на роутер!</h1>"
  echo "<p>Дополнительные страны доступны.</p>"
  echo "<p><a href='/ip.html'>На главную страницу</a></p>"
  echo "</body></html>"
else
  echo "<html><head><meta charset=\"UTF-8\"></head><body>"
  echo "<h1 style='color: red;'>Ошибка при сохранении</h1>"
  echo "<p><a href='/ip.html'>На главную страницу</a></p>"
  echo "</body></html>"
  rm -f "$TMP_CONTENT"
fi
