# nova-pausemenu

Standalone ESC menu. It replaces the native GTA pause screen. It runs with QBCore, with ESX, or with neither. It does not require another Nova script.

## Features

- **Framework:** With QBCore it reads the character name, job, gang, phone, cash, and bank. With ESX it reads the same fields. With neither it shows the player name, server id, and ping. Ensure order does not matter.
- **Camera:** Opening the menu eases the camera in front of the player. Inside a vehicle it frames the vehicle. Set `Config.CharacterScenario` to play a pose on foot. The pose stays off while the player is entering a car.
- **Languages:** `Config.Locale` is `'en'` or `'tr'`. Every label in the menu comes from `config.lua`.
- **Players:** Online list with id, name, ping, and a search box.
- **Server page:** Hostname, player count, uptime, Discord link, announcement, rules, and the key list.
- **Map and settings:** Those buttons open the native GTA map or the native settings page.
- **Disconnect:** Asks for confirmation, then drops the player with `Config.DisconnectReason`.
- **HUD:** If `nova-hud`, `qb-hud`, or `ps-hud` is started, the menu hides it and shows it again on close. None of them is required.
- **Browser preview:** Open `html/index.html` in a browser to view the layout with sample data. The sample language follows the browser.
- **Version check:** On start, `version.json` is compared with `main` on `github.com/msaber07/nova-pausemenu`. A newer version prints a line in the server console.

## Installation

1. Copy the folder to `resources/[standalone]/nova-pausemenu`.
2. Edit `config.lua`: Discord invite, announcement, rules, key list, and `Config.Locale`.
3. Write the Discord value as `discord.gg/yourserver`. Do not add `https://`.
4. Add `ensure nova-pausemenu` to `server.cfg`.

## Configuration

```lua
Config.Locale = 'en' -- 'en' or 'tr'

Config.Discord  = 'discord.gg/yourserver'
Config.SubLabel = 'v1.0.0'

Config.Announce = {
    tr = 'Hafta sonu 2x maaş etkinliği aktif!',
    en = 'Weekend 2x salary event is active!'
}
```

Rules and the key list are in the same file, each with a `tr` and an `en` entry.

## Exports

```lua
exports['nova-pausemenu']:OpenMenu()
exports['nova-pausemenu']:CloseMenu()

local isOpen = exports['nova-pausemenu']:IsOpen()
```

## License

You may use and edit this resource on your own FiveM server. You may not sell it, bundle it into a paid package, or redistribute it under another name. The Nova name stays on the resource.

---

## Türkçe

ESC tuşunda GTA'nın kendi duraklatma ekranının yerine açılan bağımsız menü. QBCore, ESX veya ikisi de yokken çalışır. Başka bir Nova scripti gerekmez.

### Özellikler

- **Framework:** QBCore varsa karakter adı, meslek, çete, telefon, nakit ve banka oradan okunur. ESX varsa aynı alanlar ESX'ten okunur. İkisi de yoksa oyuncu adı, id ve ping gösterilir. `ensure` sırası fark etmez.
- **Kamera:** Menü açılınca kamera oyuncunun önüne gelir. Araçtaysa aracı kadrajlar. `Config.CharacterScenario` yaya poz verir. Araca binerken poz çalışmaz.
- **Dil:** `Config.Locale` değeri `'en'` veya `'tr'`. Menüdeki bütün yazılar `config.lua` içindedir.
- **Oyuncular:** Id, ad, ping ve arama kutusu.
- **Sunucu sayfası:** Sunucu adı, oyuncu sayısı, uptime, Discord, duyuru, kurallar ve tuş listesi.
- **Harita ve ayarlar:** Bu iki düğme GTA'nın kendi haritasını veya ayar sayfasını açar.
- **Ayrıl:** Onay sorar, sonra oyuncuyu `Config.DisconnectReason` ile düşürür.
- **HUD:** `nova-hud`, `qb-hud` veya `ps-hud` açıksa menü onu gizler ve kapanınca geri açar. Hiçbiri zorunlu değildir.
- **Tarayıcı önizleme:** `html/index.html` dosyasını tarayıcıda aç. Örnek veri, tarayıcı diline göre TR veya EN gelir.
- **Sürüm kontrolü:** Açılışta `version.json`, `github.com/msaber07/nova-pausemenu` üzerindeki `main` ile karşılaştırılır. Yeni sürüm varsa konsola yazılır.

### Kurulum

1. Klasörü `resources/[standalone]/nova-pausemenu` altına kopyala.
2. `config.lua` içinde Discord, duyuru, kurallar, tuş listesi ve `Config.Locale` değerini düzenle.
3. Discord değerini `discord.gg/yourserver` yaz. Başına `https://` ekleme.
4. `server.cfg` içine `ensure nova-pausemenu` ekle.

### Exportlar

```lua
exports['nova-pausemenu']:OpenMenu()
exports['nova-pausemenu']:CloseMenu()

local isOpen = exports['nova-pausemenu']:IsOpen()
```

### Lisans

Kendi FiveM sunucunda kullanabilir ve düzenleyebilirsin. Bu kaynağı satamazsın, ücretli bir pakete koyamazsın ve başka bir adla dağıtamazsın. Nova adı resource üzerinde kalır.
