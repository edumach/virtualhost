#!/bin/bash

GREEN="\e[92m"
YELLOW="\e[93m"
RED="\e[91m"
RESET="\e[0m"

# Kontrola root oprávnění
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Tento skript musí být spuštěn s root oprávněním (pomocí sudo).${RESET}"
    exit 1
fi

# Zadání názvu webu k odstranění
read -p "Zadej název webu k odstranění (bez .cz): " site
if [[ -z "$site" ]]; then
    echo -e "${RED}Chyba: musíš zadat název webu.${RESET}"
    exit 1
fi

webdir="/var/www/$site"
conf="/etc/apache2/sites-available/$site.conf"

echo -e "${YELLOW}---------------------------------------"
echo "Odstraňuji virtualhost: $site"
echo "---------------------------------------${RESET}"

# 1) Deaktivace webu
if [[ -f "$conf" ]]; then
    echo -e "${YELLOW}Deaktivuji konfiguraci...${RESET}"
    a2dissite "$site.conf"
else
    echo -e "${RED}Konfigurační soubor nenalezen, přeskočeno.${RESET}"
fi

# 2) Smazání souboru konfigurace
if [[ -f "$conf" ]]; then
    echo -e "${YELLOW}Mažu konfigurační soubor...${RESET}"
    rm "$conf"
fi

# 3) Smazání adresáře webu
if [[ -d "$webdir" ]]; then
    echo -e "${YELLOW}Mažu adresář webu...${RESET}"
    rm -rf "$webdir"
fi

# 4) Smazání logů
echo "Mažu log soubory..."
rm -f /var/log/apache2/${site}_error.log
rm -f /var/log/apache2/${site}_access.log

# 5) Reload Apache
echo -e "${YELLOW}Provádím reload Apache...${RESET}"
systemctl reload apache2

echo -e "${GREEN}---------------------------------------"
echo "Virtualhost '$site' byl kompletně odstraněn."
echo -e "---------------------------------------${RESET}"
