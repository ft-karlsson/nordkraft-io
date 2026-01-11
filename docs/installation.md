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

```bash
# Tjek WireGuard status
wg show

# Tjek du kan nå API serveren
ping 172.20.0.10
```

Du burde se svar fra `172.20.0.10`.

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

1. Tjek VPN er aktiv: `wg show`
2. Tjek du kan pinge API: `ping 172.20.0.10`
3. Tjek firewall ikke blokerer WireGuard (UDP port 51820)

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
- Kontakt support@nordkraft.io med din config (uden private key!)

### Geninstaller CLI

```bash
curl -fsSL https://cloud.nordkraft.io/install.sh | sh -s -- --force
```
