# VPN Problemer

## Kan ikke forbinde til VPN

### Tjek 1: Er WireGuard installeret?

```bash
wg --version
```

Hvis ikke, se [Installation](../installation.md).

### Tjek 2: Er tunnel aktiv?

```bash
wg show
```

Du burde se din tunnel med "latest handshake" inden for de sidste 2 minutter.

### Tjek 3: Kan du pinge API serveren?

```bash
ping 172.20.0.10
```

Hvis ikke, tjek:

- Din internetforbindelse
- Firewall blokerer ikke UDP port 51820
- Din WireGuard config er korrekt

---

## "Connection refused" fra CLI

### Tjek VPN er aktiv

```bash
wg show
```

### Tjek routing

```bash
ip route | grep 172.20
```

Du burde se en route til 172.20.0.0/16 via wg0.

### Genstart WireGuard

=== "macOS/Windows"

    Deaktiver og aktiver tunnel i WireGuard app.

=== "Linux"

    ```bash
    sudo wg-quick down nordkraft
    sudo wg-quick up nordkraft
    ```

---

## Handshake fejler

Hvis `wg show` viser ingen "latest handshake":

1. **Tjek din public IP ikke har ændret sig** - Nogle ISPs giver dynamisk IP
2. **Tjek endpoint er korrekt** - Skal være `cloud.nordkraft.io:51820`
3. **Kontakt support** med din config (UDEN private key!)

---

## Stadig problemer?

Email support@nordkraft.io med:

- Output fra `wg show`
- Output fra `ping 172.20.0.10`
- Din config fil (fjern PrivateKey linjen!)
