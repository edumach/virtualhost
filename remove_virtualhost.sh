#!/bin/bash

# Kontrola root oprávnění
if [[ $EUID -ne 0 ]]; then
    echo "Tento skript musí být spuštěn s root oprávněním (pomocí sudo)."
    exit 1
fi

read -p "Zadej název webu k odstranění (bez .cz): " site

conf="/etc/apache2/sites-available/$site.conf"
webdir="/var/www/$site"

echo "---------------------------------------"
echo "Odstraňuji virtualhost: $site"
echo "---------------------------------------"

# 1) Deaktivace webu
if [[ -f "$conf" ]]; then
    echo "Deaktivuji konfiguraci..."
    a2dissite "$site.conf"
else
    echo "Konfigurace nenalezena, přeskočeno."
fi

# 2) Smazání souboru konfigurace
if [[ -f "$conf" ]]; then
    echo "Mažu konfigurační soubor..."
    rm "$conf"
else
    echo "Soubor $conf neexistuje."
fi

# 3) Smazání adresáře webu
if [[ -d "$webdir" ]]; then
    echo "Mažu adresář webu..."
    rm -rf "$webdir"
else
    echo "Adresář $webdir neexistuje."
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
