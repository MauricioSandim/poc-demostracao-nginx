# POC NGINX - Balanceamento de Carga, Escalabilidade e Tolerância a Falhas

## Objetivo

Demonstrar as capacidades do NGINX como balanceador de carga através dos seguintes cenários:

* Round Robin
* Least Connections
* Weighted Round Robin
* Tolerância a Falhas
* Escalabilidade Horizontal

---

## Arquitetura

```text
                Cliente
                   |
                   v

            +-------------+
            |    NGINX    |
            +-------------+
             /     |     \
            /      |      \

       +------+ +------+ +------+
       | App1 | | App2 | | App3 |
       +------+ +------+ +------+
```

Cada backend responde com sua identificação para facilitar a visualização da distribuição de carga.

---

## Estrutura do Projeto

```text
.
├── docker-compose.yml
├── README.md
│
├── infra/
│   └── nginx/
│       └── nginx.conf
│
├── server1/
│   └── app.py
│
├── server2/
│   └── app.py
│
├── server3/
│   └── app.py
│
└── scripts/
    ├── failover.sh
    ├── least-conn.sh
    ├── recovery.sh
    ├── round-robin.sh
    └── weighted.sh
```

---

## Subindo o Ambiente

```bash
docker compose up -d
```

### Pré-requisitos

* Docker instalado
* Docker Compose instalado
* Porta `9753` disponível

Verificar containers:

```bash
docker ps
```

Resultado esperado:

```text
nginx
app1
app2
app3
```

---

## Permissão para os Scripts

Conceder permissão de execução:

```bash
chmod +x scripts/*.sh
```

---

## Scripts Disponíveis

| Script         | Finalidade                              |
| -------------- | --------------------------------------- |
| round-robin.sh | Demonstra o algoritmo Round Robin       |
| least-conn.sh  | Demonstra o algoritmo Least Connections |
| weighted.sh    | Demonstra distribuição baseada em pesos |
| failover.sh    | Demonstra tolerância a falhas           |
| recovery.sh    | Demonstra recuperação de nós            |

---

# Cenário 1 - Round Robin

### Endpoint

```text
http://localhost:9753/rr
```

### Executar

```bash
./scripts/round-robin.sh
```

### O que o script faz

Executa diversas requisições sequenciais ao endpoint configurado com o algoritmo Round Robin.

Exemplo simplificado:

```bash
for i in {1..15}; do
  curl -s localhost:9753/rr
done
```

### Resultado esperado

```text
app1
app2
app3
app1
app2
app3
...
```

### Objetivo

Validar a distribuição sequencial padrão do NGINX.

---

# Cenário 2 - Least Connections

### Endpoint

```text
http://localhost:9753/lc
```

### Executar

```bash
./scripts/least-conn.sh
```

### O que o script faz

Gera requisições concorrentes em intervalos curtos para manter conexões simultâneas abertas.

Exemplo simplificado:

```bash
while true
do
  curl -s localhost:9753/lc &
  sleep 0.1
done
```

Os servidores possuem tempos de resposta diferentes:

```text
app1 -> 3 segundos
app2 -> 0.2 segundos
app3 -> 1 segundo
```

### Resultado esperado

```text
app2 ≈ maior quantidade de respostas
app3 ≈ quantidade intermediária
app1 ≈ menor quantidade de respostas
```

### Objetivo

Demonstrar que novas conexões são direcionadas para os servidores com menor quantidade de conexões ativas.

---

# Cenário 3 - Weighted Round Robin

### Endpoint

```text
http://localhost:9753/weight
```

### Executar

```bash
./scripts/weighted.sh
```

### O que o script faz

Executa múltiplas requisições para evidenciar a influência dos pesos configurados no NGINX.

Exemplo simplificado:

```bash
for i in {1..20}; do
  curl -s localhost:9753/weight
done
```

### Pesos configurados

```text
app1 -> weight=5
app2 -> weight=3
app3 -> weight=2
```

### Resultado esperado

```text
app1 ≈ 50%
app2 ≈ 30%
app3 ≈ 20%
```

### Objetivo

Demonstrar distribuição proporcional aos pesos configurados.

---

# Cenário 4 - Tolerância a Falhas

### Executar

```bash
./scripts/failover.sh
```

### O que o script faz

1. Interrompe o container app2.
2. Executa requisições utilizando Round Robin.
3. Demonstra que o serviço continua disponível.

Comando principal:

```bash
docker stop app2
```

### Resultado esperado

```text
app1
app3
app1
app3
...
```

### Objetivo

Demonstrar continuidade do serviço após a falha de um nó.

---

# Cenário 5 - Recuperação

### Executar

```bash
./scripts/recovery.sh
```

### O que o script faz

1. Inicia novamente o container app2.
2. Aguarda o backend ficar disponível.
3. Executa novas requisições.

Comando principal:

```bash
docker start app2
```

### Resultado esperado

```text
app1
app2
app3
app1
app2
app3
...
```

### Objetivo

Demonstrar a reintegração automática de um servidor ao pool de balanceamento.

---

# Evidências Esperadas

Ao final da execução da POC deve ser possível demonstrar:

* Distribuição sequencial utilizando Round Robin.
* Distribuição baseada em conexões ativas utilizando Least Connections.
* Distribuição proporcional utilizando pesos.
* Continuidade da aplicação após falha de um backend.
* Recuperação automática após retorno do backend.

---

# Encerramento

Remover todos os containers:

```bash
docker compose down
```

Remover também volumes e redes criadas pelo Compose:

```bash
docker compose down -v
```
