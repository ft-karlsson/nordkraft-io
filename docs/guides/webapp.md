# Deploy din egen app

Denne guide tager dig fra en Dockerfile til en kørende app på nordkraft.io — med dit eget private container registry, så du aldrig behøver at gøre dine images offentlige.

---

## Overblik

```
Din kode  →  Dockerfile  →  nordkraft registry  →  deploy
```

Tre trin:

1. Skriv en `Dockerfile`
2. Sæt dit private registry op med `nordkraft registry init`
3. Push og deploy med `nordkraft push` og `nordkraft deploy`

---

## Trin 1: Skriv en Dockerfile

Har du allerede en Dockerfile, spring til trin 2.

Her er eksempler på de mest almindelige setups:

=== "Node.js"

    ```dockerfile
    FROM node:20-alpine
    WORKDIR /app
    COPY package*.json ./
    RUN npm ci --only=production
    COPY . .
    EXPOSE 3000
    CMD ["node", "server.js"]
    ```

=== "Python"

    ```dockerfile
    FROM python:3.12-slim
    WORKDIR /app
    COPY requirements.txt .
    RUN pip install --no-cache-dir -r requirements.txt
    COPY . .
    EXPOSE 8000
    CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
    ```

=== "Go"

    ```dockerfile
    FROM golang:1.22-alpine AS builder
    WORKDIR /app
    COPY go.* ./
    RUN go mod download
    COPY . .
    RUN go build -o app .

    FROM alpine:latest
    COPY --from=builder /app/app /app
    EXPOSE 8080
    CMD ["/app"]
    ```

=== "Static (nginx)"

    ```dockerfile
    FROM node:20-alpine AS builder
    WORKDIR /app
    COPY package*.json ./
    RUN npm ci
    COPY . .
    RUN npm run build

    FROM nginx:alpine
    COPY --from=builder /app/dist /usr/share/nginx/html
    EXPOSE 80
    ```

!!! tip "Alpine images"
    Brug `:alpine` varianter hvor muligt — de er markant mindre og starter hurtigere.

---

## Trin 2: Sæt privat registry op

nordkraft.io har et indbygget OCI-kompatibelt registry der kører direkte på din instans.

```bash
nordkraft registry init
```

Output:

```
✅ Registry kører på 172.21.1.3:5001
   Gemt i ~/.nordkraft/registry.json
```

Tjek status når som helst:

```bash
nordkraft registry status
```

!!! note "Én gang"
    Du behøver kun køre `registry init` én gang. Registry persisterer og overlever genstarter.

---

## Trin 3: Push dit image

```bash
# Push til dit private registry
nordkraft push myapp:v1
```

nordkraft.io bygger automatisk fra din lokale Dockerfile, tagger og pusher til dit registry.

Se hvad der ligger i registry:

```bash
nordkraft registry list
```

Output:

```
IMAGE           TAG    SIZE     PUSHED
myapp           v1     48 MB    2 min ago
myapp           v2     49 MB    yesterday
```

---

## Trin 4: Deploy

```bash
# Deploy fra dit private registry
nordkraft deploy registry://myapp:v1 \
  -p 3000 \
  --name myapp
```

### Med environment variabler

```bash
nordkraft deploy registry://myapp:v1 \
  -p 3000 \
  --env NODE_ENV=production \
  --env DATABASE_URL=postgres://user:pass@172.21.1.5:5432/mydb \
  --name myapp
```

### Med persistent storage

```bash
nordkraft deploy registry://myapp:v1 \
  -p 3000 \
  --persistence --volume-path /app/storage \
  --env NODE_ENV=production \
  --name myapp
```

---

## Trin 5: Gør den tilgængelig

```bash
# HTTPS på nordkraft.cloud
nordkraft ingress enable myapp --subdomain myapp --port 3000
# → https://myapp.nordkraft.cloud

# Eller IPv6 direkte
nordkraft ipv6 open myapp
```

---

## Opdater til ny version

```bash
# Push ny version
nordkraft push myapp:v2

# Stop den gamle
nordkraft container stop myapp

# Deploy den nye
nordkraft deploy registry://myapp:v2 \
  -p 3000 \
  --name myapp-v2

# Flyt ingress til den nye
nordkraft ingress disable myapp
nordkraft ingress enable myapp-v2 --subdomain myapp --port 3000

# Slet den gamle når du er tilfreds
nordkraft container rm myapp
```

!!! tip "Zero-downtime deploys"
    Ved at deploye den nye version ved siden af den gamle og derefter flytte ingress, undgår du nedetid under opdateringer.

---

## Oprydning i registry

```bash
# Slet gamle images du ikke bruger mere
nordkraft registry list

# Fjern hele registry (og alle images)
nordkraft registry destroy
```

---

## Hurtig reference

| Handling | Kommando |
|----------|----------|
| Opsæt registry | `nordkraft registry init` |
| Push image | `nordkraft push myapp:v1` |
| List images | `nordkraft registry list` |
| Deploy fra registry | `nordkraft deploy registry://myapp:v1` |
| Registry status | `nordkraft registry status` |
