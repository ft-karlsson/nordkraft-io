# Hvordan Garage Cloud Virker

!!! info "Kommer snart"
    Denne guide er under udarbejdelse.

## Arkitektur oversigt

```
Din maskine → WireGuard VPN → API Server → Container Runtime → Din container
```

## Komponenter

### WireGuard VPN
Krypteret tunnel mellem dig og Garage Cloud. Din IP-adresse er din identitet.

### API Server
Modtager kommandoer fra CLI og orkestrerer containere.

### Container Runtime
Kører dine containere isoleret med Kata Containers.

### Netværk
Hver bruger får sin egen private subnet (172.21.x.0/24).
