# CLI Reference

Komplet oversigt over alle `nordkraft` kommandoer.

---

## Grundlæggende brug

```bash
nordkraft [KOMMANDO] [ARGUMENTER] [FLAG]
```

Få hjælp til enhver kommando:

```bash
nordkraft help
nordkraft [KOMMANDO] --help
```

---

## Container kommandoer

### deploy

Deploy en ny container.

```bash
nordkraft deploy IMAGE [FLAG]
```

**Argumenter:**

| Argument | Beskrivelse |
|----------|-------------|
| `IMAGE` | Container image (f.eks. `nginx:alpine`, `ghcr.io/user/app:v1`) |

**Flag:**

| Flag | Kort | Default | Beskrivelse |
|------|------|---------|-------------|
| `--port` | `-p` | - | Port(s) containeren lytter på (påkrævet) |
| `--env` | `-e` | - | Miljøvariabel (kan gentages) |
| `--cpu` | | `0.5` | CPU grænse i cores |
| `--memory` | `-m` | `512m` | Hukommelsesgrænse |
| `--persistent` | | `false` | Aktiver persistent storage |
| `--name` | `-n` | auto | Brugerdefineret container navn |

**Eksempler:**

```bash
# Simpel webserver
nordkraft deploy nginx:alpine --port 80

# Med miljøvariabler
nordkraft deploy myapp:v1 --port 3000 \
  --env NODE_ENV=production \
  --env API_KEY=secret123

# Med ressourcegrænser
nordkraft deploy myapp:v1 --port 3000 \
  --cpu 1.0 \
  --memory 1g

# Database med persistent storage
nordkraft deploy postgres:15 --port 5432 --persistent
```

---

### list

Vis alle dine containere.

```bash
nordkraft list [FLAG]
```

**Flag:**

| Flag | Beskrivelse |
|------|-------------|
| `--all` | Vis også stoppede containere |
| `--json` | Output som JSON |

**Eksempel output:**

```
NAME                              IMAGE           STATUS    IP            PORTS
app-8ade4622-fdd6-411b-afc9...   nginx:alpine    running   172.21.5.15   80/tcp
db-3fa85f64-5717-4562-b3fc...    postgres:15     running   172.21.5.16   5432/tcp
```

---

### logs

Vis logs fra en container.

```bash
nordkraft logs CONTAINER [FLAG]
```

**Flag:**

| Flag | Kort | Default | Beskrivelse |
|------|------|---------|-------------|
| `--lines` | `-n` | `100` | Antal linjer |
| `--follow` | `-f` | `false` | Følg logs i realtid |

**Eksempler:**

```bash
# Sidste 100 linjer
nordkraft logs myapp

# Sidste 50 linjer
nordkraft logs myapp --lines 50

# Følg logs live
nordkraft logs myapp --follow
```

---

### stop

Stop en kørende container.

```bash
nordkraft stop CONTAINER
```

Containeren stoppes men slettes ikke. Data bevares.

---

### start

Start en stoppet container.

```bash
nordkraft start CONTAINER
```

---

### rm

Slet en container permanent.

```bash
nordkraft rm CONTAINER [FLAG]
```

**Flag:**

| Flag | Beskrivelse |
|------|-------------|
| `--force` | Slet uden bekræftelse |

!!! warning "Advarsel"
    Dette sletter containeren og frigiver IP-adressen. Persistent data backuppes automatisk.

---

## Netværk kommandoer

### network info

Vis dine netværksoplysninger.

```bash
nordkraft network info
```

**Output:**

```
Garage:           ry
Container subnet: 172.21.5.0/24
VPN IP:           172.20.1.5
API server:       172.20.0.10
```

---

## Ingress kommandoer (HTTPS)

### ingress enable

Aktiver HTTPS adgang til en container.

```bash
nordkraft ingress enable CONTAINER [FLAG]
```

**Flag:**

| Flag | Påkrævet | Beskrivelse |
|------|----------|-------------|
| `--subdomain` | Ja | Subdomain (f.eks. `myapp` → `myapp.nordkraft.cloud`) |
| `--port` | Nej | Target port (default: containerens port) |

**Eksempel:**

```bash
nordkraft ingress enable myapp --subdomain coolsite
# Resultat: https://coolsite.nordkraft.cloud
```

---

### ingress disable

Deaktiver HTTPS adgang.

```bash
nordkraft ingress disable CONTAINER
```

---

### ingress status

Vis ingress status for en container.

```bash
nordkraft ingress status CONTAINER
```

---

### ingress list

Vis alle dine ingress routes.

```bash
nordkraft ingress list
```

---

## IPv6 kommandoer

### ipv6 open

Åbn firewall for containerens IPv6 adresse.

```bash
nordkraft ipv6 open CONTAINER
```

Gør containeren tilgængelig på en global IPv6 adresse.

---

### ipv6 close

Luk firewall for IPv6.

```bash
nordkraft ipv6 close CONTAINER
```

---

### ipv6 status

Vis IPv6 status.

```bash
nordkraft ipv6 status CONTAINER
```

---

### ipv6 list

Vis alle IPv6 allokeringer.

```bash
nordkraft ipv6 list
```

---

## Auth kommandoer

### auth login

Bekræft din authentication og forbindelse.

```bash
nordkraft auth login
```

**Output:**

```
✓ Sikker forbindelse etableret til Dit Navn!
```

---

### auth status

Vis detaljeret auth status.

```bash
nordkraft auth status
```

---

## System kommandoer

### status

Vis systemstatus.

```bash
nordkraft status
```

---

### nodes

Vis tilgængelige nodes.

```bash
nordkraft nodes
```

---

### version

Vis CLI version.

```bash
nordkraft --version
```

---

## Globale flag

Disse flag virker på alle kommandoer:

| Flag | Beskrivelse |
|------|-------------|
| `--help` | Vis hjælp |
| `--json` | Output som JSON |
| `--quiet` | Minimal output |
| `--verbose` | Detaljeret output |

---

## Exit koder

| Kode | Betydning |
|------|-----------|
| `0` | Succes |
| `1` | Generel fejl |
| `2` | Ugyldig kommando/argumenter |
| `3` | Authentication fejl |
| `4` | Netværksfejl |
| `5` | Container ikke fundet |
