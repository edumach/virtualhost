#!/bin/bash

# Barevné konstanty
GREEN="\e[92m"
YELLOW="\e[93m"
RED="\e[91m"
RESET="\e[0m"


# Kontrola root oprávnění
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Tento skript musí být spuštěn s root oprávněním (pomocí sudo).${RESET}"
    exit 1
fi

# Zadání názvu webu
read -p "Zadej název webu (bez .cz): " site
if [[ -z "$site" ]]; then
    echo -e "${RED}Chyba: musíš zadat název webu.${RESET}"
    exit 1
fi

webdir="/var/www/$site"
conf="/etc/apache2/sites-available/$site.conf"

echo "---------------------------------------"
echo -e "${YELLOW}Vytvářím virtualhost: $site${RESET}"
echo "---------------------------------------"

# 1) Vytvořit adresář pro web
rm -rf "$webdir" 2> /dev/null
mkdir -p "$webdir"

# 2) Vytvořit základní index.html
cat <<EOF > "$webdir/index.html"
<h1>$site.cz</h1>
<p>Vítejte na webu $site.cz</p>
EOF

# 3) Nastavení oprávnění
chown -R www-data:www-data "$webdir"
find "$webdir" -type d -exec chmod 755 {} \;
find "$webdir" -type f -exec chmod 644 {} \;

# 4) Vytvoření konfigurace
cat <<EOF > "$conf"
<VirtualHost *:80>
    ServerName $site.cz
    DocumentRoot /var/www

    Alias /$site.cz /var/www/$site

    <Directory /var/www/$site>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/${site}_error.log
    CustomLog /var/log/apache2/${site}_access.log combined
</VirtualHost>
EOF

# 5) Aktivace webu a reload Apache
a2ensite "$site.conf"
systemctl reload apache2

echo -e "${GREEN}---------------------------------------"
echo "Hotovo."
echo "Web je připraven na http://192.168.21.nnn/$site.cz"
echo "---------------------------------------${RESET}"
