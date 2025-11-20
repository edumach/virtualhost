#!/bin/bash

# Kontrola root oprávnění
if [[ $EUID -ne 0 ]]; then
    echo "Tento skript musí být spuštěn s root oprávněním (pomocí sudo)."
    exit 1
fi

# Zadání názvu webu k odstranění
read -p "Zadej název webu k odstranění (bez .cz): " site
if [[ -z "$site" ]]; then
    echo "Chyba: musíte zadat název webu."
    exit 1
fi

webdir="/var/www/$site"
conf="/etc/apache2/sites-available/$site.conf"

echo "---------------------------------------"
echo "Odstraňuji virtualhost: $site"
echo "---------------------------------------"

# 1) Deaktivace webu
if [[ -f "$conf" ]]; then
    echo "Deaktivuji konfiguraci..."
    a2dissite "$site.conf"
else
    echo "Konfigurační soubor nenalezen, přeskočeno."
fi

# 2) Smazání souboru konfigurace
if [[ -f "$conf" ]]; then
    echo "Mažu konfigurační soubor..."
    rm "$conf"
fi

# 3) Smazání adresáře webu
if [[ -d "$webdir" ]]; then
    echo "Mažu adresář webu..."
    rm -rf "$webdir"
fi

# 4) Smazání logů
echo "Mažu log soubory..."
rm -f /var/log/apache2/${site}_error.log
rm -f /var/log/apache2/${site}_access.log

# 5) Reload Apache
echo "Provádím reload Apache..."
systemctl reload apache2

echo "---------------------------------------"
echo "Virtualhost '$site' byl kompletně odstraněn."
echo "---------------------------------------"
