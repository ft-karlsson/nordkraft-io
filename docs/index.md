# NordKraft Garage Cloud

**Simple. Green. Secure.**

Velkommen til dokumentationen for NordKraft Garage Cloud - en dansk container-platform bygget på genbrugt hardware.

---

## Hvad er Garage Cloud?

Garage Cloud er container hosting med fokus på:

- **Simplicitet** - Deploy med én kommando
- **Bæredygtighed** - Kører på genbrugt hardware, drevet af grøn energi
- **Sikkerhed** - WireGuard VPN, isolerede netværk, zero-trust arkitektur
- **Gennemsigtighed** - Du ved præcis hvor din kode kører

---

## Kom hurtigt i gang

### 1. Installer CLI

```bash
# macOS / Linux
curl -fsSL https://cloud.nordkraft.io/install.sh | sh
```

### 2. Forbind til VPN

Import din WireGuard-konfiguration (modtaget via email) og forbind.

### 3. Verificer forbindelse

```bash
nordkraft auth login
```

### 4. Deploy din første container

```bash
nordkraft deploy nginx:alpine --port 80
```

**Det var det!** Din container kører nu på dansk hardware.

[→ Fuld guide: Din første container](getting-started.md)

---

## Populære guides

| Guide | Beskrivelse |
|-------|-------------|
| [Din første container](getting-started.md) | Fra nul til kørende container på 30 minutter |
| [Installation](installation.md) | CLI + VPN setup |
| [CLI Reference](reference/cli.md) | Alle kommandoer |
| [Databaser](guides/databases.md) | PostgreSQL, MySQL, Redis |
| [HTTPS & Domæner](guides/domains.md) | Automatisk TLS certifikat |

---

## CLI hurtigreference

| Handling | Kommando |
|----------|----------|
| Deploy container | `nordkraft deploy IMAGE --port PORT` |
| Se containere | `nordkraft list` |
| Se logs | `nordkraft logs NAVN` |
| Stop container | `nordkraft stop NAVN` |
| Slet container | `nordkraft rm NAVN` |
| Aktiver HTTPS | `nordkraft ingress enable NAVN --subdomain X` |
| Åbn IPv6 | `nordkraft ipv6 open NAVN` |

[→ Fuld CLI reference](reference/cli.md)

---

## Brug for hjælp?

- **Email:** support@nordkraft.io (besvaret af mennesker)
- **GitHub Issues:** [github.com/ft-karlsson/nordkraft-io/issues](https://github.com/ft-karlsson/nordkraft-io/issues)

---

<small>
NordKraft Garage Cloud - Bygget i Ry, Danmark 🇩🇰<br>
Kører på genbrugt Dell OptiPlex og Raspberry Pi hardware.
</small>
