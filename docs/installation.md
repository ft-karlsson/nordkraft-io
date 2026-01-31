# Installation

Sådan får du NordKraft CLI og VPN sat op på din maskine.

---

## Forudsætninger

- En NordKraft konto (du modtager invitation via email)
- macOS, Linux eller Windows
- Terminal/kommandolinje adgang

---

## Trin 1: Installer NordKraft CLI

### One-liner installation (anbefalet)

=== "macOS"

    ```bash
    curl -fsSL https://cloud.nordkraft.io/install.sh | sh
    ```

=== "Linux"

    ```bash
    bash <(curl -fsSL https://cloud.nordkraft.io/install.sh)
    ```

### Manuel installation

Download binary fra [GitHub Releases](https://github.com/ft-karlsson/nordkraft-io/releases/latest):

| Platform | Fil |
|----------|-----|
| macOS (Apple Silicon) | `nordkraft-darwin-arm64.tar.gz` |
| macOS (Intel) | `nordkraft-darwin-amd64.tar.gz` |
| Linux (AMD64) | `nordkraft-linux-amd64.tar.gz` |

```bash
# Udpak og installer
tar -xzf nordkraft-*.tar.gz
sudo mv nordkraft /usr/local/bin/
```

### Verificer installation

```bash
nordkraft --version
```

---

## Trin 2: Installer WireGuard

WireGuard er VPN-softwaren der sikrer din forbindelse til Garage Cloud.

=== "macOS"

    Download fra App Store:
    
    [WireGuard på Mac App Store](https://apps.apple.com/us/app/wireguard/id1451685025){ .md-button }
    
    Eller via Homebrew:
    ```bash
    brew install wireguard-tools
    ```

=== "Linux (Ubuntu/Debian)"

    ```bash
    sudo apt update
    sudo apt install wireguard
    ```

=== "Linux (Fedora)"

    ```bash
    sudo dnf install wireguard-tools
    ```

=== "Windows"

    Download fra den officielle side:
    
    [WireGuard til Windows](https://www.wireguard.com/install/){ .md-button }

---

## Trin 3: Konfigurer WireGuard

Du har modtaget en WireGuard-konfigurationsfil via email (`nordkraft.conf`).

=== "macOS/Windows (GUI)"

    1. Åbn WireGuard-appen
    2. Klik **"Import tunnel(s) from file"**
    3. Vælg `nordkraft.conf` filen
    4. Klik **"Activate"** for at forbinde

=== "Linux (CLI)"

    ```bash
    # Kopier config til WireGuard mappe
    sudo cp nordkraft.conf /etc/wireguard/
    
    # Start forbindelse
    sudo wg-quick up nordkraft
    
    # (Valgfrit) Start automatisk ved boot
    sudo systemctl enable wg-quick@nordkraft
    ```

### Bekræft forbindelse

=== "macOS/Windows (GUI)"

    I WireGuard-appen, klik på din tunnel og tjek følgende:
    
    - **Latest handshake:** Skal vise tid (f.eks. "41 seconds ago")
    - **Data received/sent:** Begge skal vise data (f.eks. "2.60 KiB / 1.95 KiB")
    
    !!! tip "Tjek handshake"
        Hvis "Latest handshake" ikke vises eller er mere end 2 minutter gammel, 
        prøv at deaktivere og genaktivere tunnelen.

=== "Linux (CLI)"

    ```bash
    # Tjek WireGuard status (kræver sudo)
    sudo wg show
    ```
    
    Du burde se output med en aktiv peer og "latest handshake" inden for de sidste minutter.

**Test forbindelse til API serveren:**

```bash
# API serveren svarer kun på HTTP requests
curl -s http://172.20.0.254:8001/api/status
```

Forventet output:

```json
{"status":"online","timestamp":"2025-01-31T12:00:00Z"}
```

---

## Trin 4: Verificer alt virker

```bash
nordkraft auth login
```

Forventet output:

```
✓ Sikker forbindelse etableret til Dit Navn!
```

---

## Næste skridt

Du er klar! Gå til [Din første container](getting-started.md) for at deploye din første app.

---

## Fejlfinding

### "Connection refused" ved auth login

1. **GUI (macOS/Windows):** Tjek i WireGuard-appen at tunnelen er aktiv og har et recent handshake
2. **CLI (Linux):** Kør `sudo wg show` og tjek der er en aktiv peer med recent handshake
3. Test HTTP forbindelse: `curl http://172.20.0.254:8001/api/status`
4. Tjek firewall ikke blokerer WireGuard (UDP port 51820)

### "Command not found: nordkraft"

CLI er ikke i din PATH. Prøv:

```bash
# Find hvor den blev installeret
which nordkraft

# Eller tilføj manuelt til PATH
export PATH="$PATH:/usr/local/bin"
```

### WireGuard forbinder ikke

- Tjek din internetforbindelse
- Tjek config-filen ikke er beskadiget
- **GUI:** Prøv at deaktivere og genaktivere tunnelen
- **Linux:** Kør `sudo wg-quick down nordkraft && sudo wg-quick up nordkraft`
- Kontakt <frederikkarlsson@me.com> med din config (uden private key!)

### Ingen handshake i WireGuard

Hvis du ikke ser "Latest handshake" i GUI'en eller `wg show`:

- Din firewall blokerer måske UDP port 51820 udgående
- Prøv fra et andet netværk (nogle virksomhedsnetværk blokerer WireGuard)
- Tjek at endpoint IP'en i din config er korrekt

### Geninstaller CLI

```bash
curl -fsSL https://cloud.nordkraft.io/install.sh | sh -s -- --force
```
