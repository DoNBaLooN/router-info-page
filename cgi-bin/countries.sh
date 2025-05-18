#!/bin/sh
echo "Content-Type: application/json"
echo

FILE=/www/country/subscriptions.txt
[ -r "$FILE" ] || {
  printf '[]'
  exit 0
}

printf '['
first=1
while IFS= read -r line || [ -n "$line" ]; do
  # убираем возможный CR
  line="${line%$'\r'}"
  country=${line%%:*}
  link=${line#*: }
  [ -z "$country" ] && continue

  if [ $first -eq 1 ]; then
    first=0
  else
    printf ','
  fi

  # экранируем кавычки в country/link, если нужно
  printf '{"country":"%s","link":"%s"}' "$country" "$link"
done < "$FILE"
printf ']'
