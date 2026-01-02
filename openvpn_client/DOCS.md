Home Assistant OpenVPN add-on
=============================

This add-on runs OpenVPN using the provided configuration.
Configuration files can be uploaded and downloaded via the add-on web page.

Add-on Configuration
--------------------

**Install**, then **Start** the add-on and **Open web UI**.  The web UI shows the status of the OpenVPN files and the OpenVPN process.  The two files are the main configuration file (.ovpn) and the username/password file (.text).

For each file, use **Browse** to select the file on the local file system, then **Upload** it.

The add-on checks every minute for configuration files and starts OpenVPN when they are found.  After the files are uploaded, OpenVPN should start within a minute.  The current status can be checked using the **Reload** button.

If the configuration files are changed, the add-on will not automatically restart OpenVPN.  **Restart** from the main add-on page to restart the add-on with the new configuration.

Add-on Logs
-----------

The add-on outputs its current status to the log.  When the configuration files are available and OpenVPN is running, the OpenVPN output is displayed in the log.  Any OpenVPN errors will also be written to the log.

Česky
=====

Tento doplněk spouští OpenVPN pomocí poskytnuté konfigurace.  Konfigurační soubory lze nahrát a stánout na webové stránce doplňku.

Konfigurace doplňku
-------------------

**Nainstalovat**, pak **Spustit** a **Otevřít webové rozhraní**.  Webové rozhraní zobrazuje stav souborů OpenVPN a proces OpenVPN. Dva soubory jsou hlavní konfigurační soubor (.ovpn) a soubor s uživatelským jménem/heslem (.text).

Pro každý soubor použijte **Browse** k výběru souboru v lokálním souborovém systému a pak jeho **Upload**.

Doplněk každou minutu kontroluje konfigurační soubory a po jejich nalezení spustí OpenVPN.  Po nahrání souborů by se OpenVPN měl spustit do minuty.  Aktuální stav lze zkontrolovat pomocí tlačítka **Reload**.

Pokud se konfigurační soubory změní, doplněk OpenVPN automaticky nerestartuje. **Restartovat** z hlavní stránky doplňku, abyste doplněk restartovali s novou konfigurací.

Logy doplňku
------------

Doplněk zaznamenává svůj aktuální stav do logu. Když jsou konfigurační soubory k dispozici a OpenVPN je spuštěn, OpenVPN zaznamenává stav do logu. Do logu budou také zapsány všechny chyby OpenVPN.
