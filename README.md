# VlessWB — статусная страница для OpenWRT

Лёгкая HTML-страница для маршрутизаторов на OpenWRT, отображающая:

- IP-адрес WAN-интерфейса
- IP-адрес интерфейса ZeroTier
- Статус работы DNS (DoH/DoT)
- Адаптированный внешний вид (на русском языке)

---

## 🚀 Установка

На роутере выполните команду:

```sh
wget -O - https://raw.githubusercontent.com/DoNBaLooN/router-info-page/main/install.sh | sh

