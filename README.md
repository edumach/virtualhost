# Správa VirtualHostů pro Apache na Debianu

Tyto skripty slouží k rychlému vytváření a odstraňování testovacích virtualhostů na Apache serveru. Jsou určeny pro prostředí Debian a využívají barevný výstup pro lepší přehlednost.

## Skripty

### 1. `create_vhost.sh`

- Vytváří nový virtualhost s aliasem ve tvaru `http://192.168.21.nnn/<nazev_webu>.cz`
- Automaticky vytvoří adresář `/var/www/<nazev_webu>` a jednoduchou stránku `index.html`
- Nastaví správného vlastníka a oprávnění (adresáře 755, soubory 644)
- Vytvoří konfiguraci v `/etc/apache2/sites-available/` s aliasem a logy
- Aktivuje web (`a2ensite`) a provede reload Apache
- Barevný výstup:  
  - 🟢 zelená = úspěch  
  - 🟡 žlutá = informace  
  - 🔴 červená = chyba

### 2. `delete_vhost.sh`

- Komplexně odstraní zvolený virtualhost
  - deaktivuje web (`a2dissite`)  
  - smaže konfiguraci `/etc/apache2/sites-available/<nazev_webu>.conf`  
  - smaže adresář `/var/www/<nazev_webu>`  
  - smaže logy `/var/log/apache2/<nazev_webu>_*.log`  
  - reload Apache
- Barevný výstup stejný jako u skriptu pro vytvoření

## Použití

1. Spustit skript s root oprávněním:

```bash
sudo ./create_vhost.sh
sudo ./delete_vhost.sh
```
