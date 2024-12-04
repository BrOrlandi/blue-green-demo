# Traefik

## Configurando senha:

Rode o comando abaixo para gerar a senha:

```sh
htpasswd -nbB admin suaSenhaSegura
```

- Copie para o arquivo `traefik_dynamic.yml` e descomente as linhas para ativar a autenticação.
- Descomente também a linha da autenticação no `docker-compose.yml`
