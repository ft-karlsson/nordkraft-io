# Environment Variabler

!!! info "Kommer snart"
    Denne guide er under udarbejdelse.

## Quick start

```bash
nordkraft deploy myapp:v1 --port 3000 \
  --env NODE_ENV=production \
  --env DATABASE_URL=postgres://user:pass@172.21.5.16:5432/mydb \
  --env API_KEY=secret123
```

Miljøvariabler sendes sikkert til containeren og er ikke synlige for andre brugere.
