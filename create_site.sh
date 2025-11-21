#!/bin/bash

# Skript vytvoří nový web jako adresář ve /var/www/html

read -p "Zadejte název webu (např. caje.cz): " site

# Cílová cesta
target="/var/www/html/$site"

# Kontrola, zda už existuje
if [ -d "$target" ]; then
    echo -e "\e[31mAdresář $target již existuje.\e[0m"
    exit 1
fi

# Vytvoření adresáře
mkdir -p "$target"

# Nastavení práv
chown -R www-data:www-data "$target"
chmod 755 "$target"

# Vytvoření jednoduchého index.html
echo "<h1>$site</h1>" > "$target/index.html"
echo "<p>Vítejte na webu $site</p>" >> "$target/index.html"

# Barevná zelená zpráva
echo -e "\e[92m---------------------------------------"
echo -e "Web '$site' byl vytvořen v $target"
echo -e "---------------------------------------\e[0m"
