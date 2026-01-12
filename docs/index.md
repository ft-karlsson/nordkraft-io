# NordKraft Garage Cloud

**Enkelt. Bæredygtigt. sikkert.**

Velkommen til dokumentationen for NordKraft.io Garage Cloud - en dansk container-platform bygget på genbrugt hardware.

---

## Hvad er så en Garage Cloud?

Nordkraft.io's Garage Cloud er container hosting med fokus på:

- **Simplicitet** - Udgiv apps med én kommando eller få komanndoer
- **Bæredygtighed** - Kører på genbrugt hardware, grøn energi (i form af solceller) & anvendelse af eksisterende bygninger (ingen nye datacentre).
- **Sikkerhed** - WireGuard VPN, isolerede netværk, zero-trust arkitektur, brug af kata containers.
- **Gennemsigtighed** - Brug af opensource til at drive platformen, og Garage cloud er open source selv - få samme løsning til at køre derhjemme hos dig. Se open source kode her: [https://github.com/ft-karlsson/nordkraft-io](https://github.com/ft-karlsson/nordkraft-io)

---

## Kom hurtigt i gang

### 1. Installer CLI

```bash
# macOS / Linux
curl -fsSL https://cloud.nordkraft.io/install.sh | sh
```

### 2. Forbind til VPN

Import din WireGuard-konfiguration (signup: [cloud.nordkraft.io](https://cloud.nordkraft.io)) og forbind.

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

!!! note "Er den så tilgængeligt online?"
    Nej. Den er ikke offentligt tilgængelig på internettet endnu. Du kan nå den via wireguard på dens lokale ip addresse.
    Du skal speficikt bede om at åbne den for "verden" med "ingress". Se guide [her]("https://docs.nordkraft.io/getting-started/#trin-7-gr-den-tilgngelig-fra-internettet")
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

- **Email:** frederikkarlsson@me.com
- **GitHub Issues:** [github.com/ft-karlsson/nordkraft-io/issues](https://github.com/ft-karlsson/nordkraft-io/issues)

---

<small>
NordKraft Garage Cloud - Bygget i Ry, Danmark 🇩🇰<br>
Kører på genbrugt / refurbished Dell og Raspberry Pi hardware.
</small>
