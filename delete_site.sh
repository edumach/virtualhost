#!/bin/bash

# Skript smaže podadresář webu z /var/www/html

read -p "Zadejte název webu ke smazání (např. caje.cz): " site

target="/var/www/html/$site"

# Kontrola existence
if [ ! -d "$target" ]; then
    echo -e "\e[31mAdresář $target neexistuje.\e[0m"
    exit 1
fi

# Potvrzení
read -p "Opravdu chcete smazat $target? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "Zrušeno."
    exit 0
fi

# Smazání
rm -rf "$target"

# Barevná zelená zpráva
echo -e "\e[92m---------------------------------------"
echo -e "Web '$site' byl kompletně odstraněn."
echo -e "---------------------------------------\e[0m"
