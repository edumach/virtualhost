#!/bin/bash

# Kontrola, zda skript běží jako root
if [[ $EUID -ne 0 ]]; then
    echo "Tento skript musí být spuštěn s root oprávněním (pomocí sudo)."
    exit 1
fi

# vstupní název
read -p "Zadej název webu (bez .cz): " site

if [[ -z "$site" ]]; then
    echo "Chyba: musíš zadat název."
    echo "bylinky nebo caje"
    exit 1
fi

cesta="/etc/apache2/sites-available/$site.conf"

# Vytvořit adresář pro web
rm -rf /var/www/$site 2> /dev/null
mkdir -p /var/www/$site

# Oprávnění
chown -R www-data:www-data /var/www/$site

# Konfigurace
cat <<EOF > "$cesta"
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

# Aktivace
a2ensite "$site.conf"
systemctl reload apache2

# vytvoření index.html
echo "<h1>$site.cz</h1>" > /var/www/$site/index.html
echo "<p>Vítejte na webu $site.cz</p>" >> /var/www/$site/index.html
# a nastavení oprávnění
chown www-data:www-data /var/www/$site/index.html
chmod 644 /var/www/$site/index.html

echo "-------------------------"
echo "Hotovo."
echo "Web je připraven na http://192.168.21.nnn/$site.cz"
echo "------------------------"

