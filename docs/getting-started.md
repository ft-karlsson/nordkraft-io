# Din Første Container

Denne guide tager dig fra nul til en kørende container på Garage Cloud - trin for trin.

**Tidsforbrug:** Ca. 30 minutter første gang.

---

## Før du starter

Du skal have følgende klar:

- [x] NordKraft konto (modtaget via email)
- [x] WireGuard VPN installeret og forbundet
- [x] `nordkraft` CLI installeret
- [x] GitHub konto (gratis - [opret her](https://github.com/signup))

### Tjek at alt virker

Åbn din terminal og kør:

```bash
nordkraft auth login
```

Du burde se noget lignende:

```
✓ Sikker forbindelse etableret til Dit Navn!
```

Hvis du får en fejl, tjek at din VPN er forbundet (se [VPN Troubleshooting](troubleshooting/vpn.md)).

---

## Hvad er en container?

En container er en **pakket applikation** - din kode, plus alt hvad den har brug for at køre (libraries, runtime, config). 

Tænk på det som en flyttekasse: alt er pakket sammen, og kassen virker ens uanset hvor du stiller den.

**Fordele:**

- Virker ens på din laptop og i produktion
- Starter på sekunder (ikke minutter som en VM)
- Isoleret fra andre containere
- Nem at dele og deploye

---

## Trin 1: Kør en færdig container

Lad os starte med noget der bare virker - en nginx webserver:

```bash
nordkraft deploy nginx:alpine --port 80
```

**Hvad sker der?**

1. NordKraft henter `nginx:alpine` fra Docker Hub (et offentligt bibliotek af containere)
2. Starter containeren på Garage Cloud hardware
3. Giver den en privat IP-adresse på dit netværk

Se resultatet:

```bash
nordkraft list
```

Output:

```
NAME                              IMAGE          STATUS    IP
app-8ade4622-fdd6-411b-afc9...   nginx:alpine   running   172.21.5.15
```

Test at den virker:

```bash
curl http://172.21.5.15
```

Du får nginx's velkomstside. **Tillykke - din første container kører!**

---

## Trin 2: Forstå image-navnet

`nginx:alpine` består af to dele:

| Del | Betydning |
|-----|-----------|
| `nginx` | Navnet på applikationen |
| `alpine` | Version/variant (Alpine Linux = lille og hurtig) |

Andre eksempler:

- `postgres:15` - PostgreSQL database, version 15
- `redis:latest` - Redis cache, nyeste version
- `ghcr.io/username/myapp:v1` - Dit eget image på GitHub

---

## Trin 3: Byg dit eget image

Nu laver vi noget **du** har bygget.

### Opret en projektmappe

```bash
mkdir hello-nordkraft
cd hello-nordkraft
```

### Lav en simpel webside

Opret filen `index.html`:

```bash
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Min Første Container</title>
    <style>
        body { 
            font-family: system-ui, sans-serif; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            color: white;
            margin: 0;
        }
        .box {
            text-align: center;
            padding: 2rem 3rem;
            border: 2px solid #4ade80;
            border-radius: 12px;
            background: rgba(0,0,0,0.3);
        }
        h1 { color: #4ade80; margin-bottom: 0.5rem; }
        code { 
            background: rgba(255,255,255,0.1); 
            padding: 0.2rem 0.5rem; 
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="box">
        <h1>🚀 Hello fra Garage Cloud!</h1>
        <p>Min første container - bygget af mig selv</p>
        <p><small>Kører på genbrugt hardware i Danmark</small></p>
    </div>
</body>
</html>
EOF
```

### Opret en Dockerfile

En `Dockerfile` er **opskriften** på din container - hvilken base der bruges, og hvad der skal kopieres ind:

```bash
cat > Dockerfile << 'EOF'
# Start fra nginx webserver (Alpine = lille Linux variant)
FROM nginx:alpine

# Kopier din webside ind i nginx's mappe
COPY index.html /usr/share/nginx/html/

# Dokumenter at containeren bruger port 80
EXPOSE 80
EOF
```

**Det var det!** Din container er defineret i to filer:

- `index.html` - indholdet
- `Dockerfile` - opskriften

---

## Trin 4: Byg dit container-image

For at bygge images lokalt skal du bruge Podman (eller Docker).

### Installer Podman

=== "macOS"

    ```bash
    brew install podman
    podman machine init
    podman machine start
    ```

=== "Linux (Ubuntu/Debian)"

    ```bash
    sudo apt update
    sudo apt install podman
    ```

=== "Windows"

    Download fra [podman.io](https://podman.io/getting-started/installation)

### Byg image

```bash
podman build -t hello-nordkraft:v1 .
```

Output:

```
STEP 1/3: FROM nginx:alpine
STEP 2/3: COPY index.html /usr/share/nginx/html/
STEP 3/3: EXPOSE 80
Successfully tagged localhost/hello-nordkraft:v1
```

### Test lokalt (valgfrit)

```bash
# Start containeren på din egen maskine
podman run -d -p 8080:80 hello-nordkraft:v1

# Åbn i browser
open http://localhost:8080    # macOS
xdg-open http://localhost:8080  # Linux

# Stop når du er færdig
podman stop $(podman ps -q)
```

---

## Trin 5: Upload til GitHub

Dit image skal uploades til et **container registry** - et sted hvor NordKraft kan hente det fra. Vi bruger GitHub's gratis registry.

### Opret adgangstoken på GitHub

1. Gå til [github.com/settings/tokens](https://github.com/settings/tokens)
2. Klik **"Generate new token (classic)"**
3. Giv den et navn: `nordkraft-containers`
4. Vælg disse rettigheder:
   - `write:packages`
   - `read:packages`
   - `delete:packages`
5. Klik **"Generate token"**
6. **Kopier token** (du ser den kun én gang!)

### Login til GitHub Container Registry

```bash
podman login ghcr.io -u DIT_GITHUB_BRUGERNAVN
```

Når den beder om password, paste dit token.

### Upload dit image

```bash
# Erstat DIT_GITHUB_BRUGERNAVN med dit faktiske brugernavn (små bogstaver!)
podman tag hello-nordkraft:v1 ghcr.io/DIT_GITHUB_BRUGERNAVN/hello-nordkraft:v1
podman push ghcr.io/DIT_GITHUB_BRUGERNAVN/hello-nordkraft:v1
```

### Gør image offentligt tilgængeligt

GitHub gør nye packages private som standard. For at NordKraft kan hente det:

1. Gå til `github.com/DIT_GITHUB_BRUGERNAVN?tab=packages`
2. Klik på `hello-nordkraft`
3. Klik **"Package settings"** (højre side)
4. Under "Danger Zone" → **"Change visibility"** → **"Public"**

!!! note "Hvorfor public?"
    Mark I understøtter kun offentlige images. Private registry-support kommer i en senere version.

---

## Trin 6: Deploy til Garage Cloud

Nu det spændende - deploy dit eget image:

```bash
nordkraft deploy ghcr.io/DIT_GITHUB_BRUGERNAVN/hello-nordkraft:v1 --port 80
```

### Hvad sker der bag kulisserne?

```
1. GODKENDELSE
   └── Din VPN-forbindelse verificerer hvem du er

2. NETVÆRK
   ├── Finder din private subnet (172.21.x.0/24)
   └── Tildeler en IP til containeren

3. SIKKERHED
   ├── Starter container i isoleret miljø
   ├── Begrænser CPU og hukommelse
   └── Låser filsystem (read-only)

4. START
   └── Container kører og er klar!
```

### Se din container

```bash
nordkraft list
```

### Test den

```bash
curl http://172.21.5.XX   # Erstat XX med din containers IP
```

Du burde se din egen "Hello fra Garage Cloud!" side.

---

## Trin 7: Gør den tilgængelig fra internettet

Din container er nu kun tilgængelig via VPN. Her er to måder at åbne den for verden:

### Option A: HTTPS med automatisk certifikat (anbefalet)

```bash
nordkraft ingress enable CONTAINER_NAVN --subdomain mitsite
```

**Resultat:**

```
✓ https://mitsite.nordkraft.cloud er nu aktiv
  - Automatisk HTTPS certifikat
  - HTTP redirecter til HTTPS
```

Del linket med hvem som helst!

### Option B: Direkte IPv6 adresse

```bash
nordkraft ipv6 open CONTAINER_NAVN
```

**Resultat:**

```
✓ Container tilgængelig på IPv6
  Adresse: 2a05:f6c3:444e:0:5:1::15
  URL: http://[2a05:f6c3:444e:0:5:1::15]/
```

Dette giver din container en **global IPv6 adresse** - direkte tilgængelig uden NAT eller proxy.

---

## Administrer din container

### Se alle dine containere

```bash
nordkraft list
```

### Se logs

```bash
nordkraft logs CONTAINER_NAVN
```

### Stop (pause)

```bash
nordkraft stop CONTAINER_NAVN
```

Containeren stoppes men slettes ikke. Data bevares.

### Start igen

```bash
nordkraft start CONTAINER_NAVN
```

### Slet permanent

```bash
nordkraft rm CONTAINER_NAVN
```

IP-adressen frigives og kan bruges af andre containere.

---

## Sikkerhed: Hvad NordKraft gør for dig

| Trussel | NordKraft's Beskyttelse |
|---------|------------------------|
| Container escape | Kata Containers (VM isolation) |
| Netværks-sniffing | Isolerede subnets per bruger |
| Privilege escalation | Dropped capabilities, no-new-privileges |
| Rootkit installation | Read-only root filesystem |
| Resource exhaustion | CPU/memory limits, PID limits |
| Uautoriseret adgang | WireGuard VPN + public key auth |

**Du behøver ikke tænke på dette** - det er indbygget i platformen.

---

## Hvad nu?

Du har nu lært det grundlæggende! Her er ideer til næste skridt:

### Deploy en database

```bash
nordkraft deploy postgres:15-alpine --port 5432 --persistent
```

`--persistent` gemmer data selvom containeren genstarter.

### Tilføj miljøvariabler

```bash
nordkraft deploy myapp:v1 --port 3000 \
  --env NODE_ENV=production \
  --env DATABASE_URL=postgres://...
```

### Se flere eksempler

- [Deploy en Node.js app](guides/webapp.md)
- [Opsæt en database](guides/databases.md)
- [Custom domæner](guides/domains.md)
- [Deploy din egen chat-server (Campfire / Mattermost)](guides/chat.md)

---

## Hurtig reference

| Handling | Kommando |
|----------|----------|
| Deploy | `nordkraft deploy IMAGE --port PORT` |
| Liste | `nordkraft list` |
| Logs | `nordkraft logs NAVN` |
| Stop | `nordkraft stop NAVN` |
| Start | `nordkraft start NAVN` |
| Slet | `nordkraft rm NAVN` |
| HTTPS | `nordkraft ingress enable NAVN --subdomain X` |
| IPv6 | `nordkraft ipv6 open NAVN` |
| Netværk info | `nordkraft network info` |
| Tjek login | `nordkraft auth login` |

---

## Problemer?

Se [Troubleshooting](troubleshooting/vpn.md) eller skriv til support@nordkraft.io - vi svarer menneskeligt.
