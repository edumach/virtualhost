#!/bin/bash

read -p "Zadej název webu (bez .cz): " site

if [[ -z "$site" ]]; then
    echo "Chyba: musíš zadat název."
    echo "bylinky nebo caje"
    exit 1
fi

cesta="/etc/apache2/sites-available/$site.conf"

# 1) Vytvořit adresář pro web
rm -rf /var/www/$site 2> /dev/null
mkdir -p /var/www/$site

# 2) Oprávnění
chown -R www-data:www-data /var/www/$site

# 3) Konfigurace
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

# 4) Aktivace
a2ensite "$site.conf"
systemctl reload apache2

echo "-------------------------"
echo "Hotovo."
echo "Web je připraven na http://192.168.21.nnn/$site.cz"
echo "------------------------"

