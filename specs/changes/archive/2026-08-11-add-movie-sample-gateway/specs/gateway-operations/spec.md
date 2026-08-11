## ADDED Requirements

### Requirement: Hosts downstream configuráveis via variável de ambiente
O gateway SHALL resolver o host de `movie-sample-server` a partir da variável de ambiente `SERVER_URI`, com default `http://localhost:8081`, e o host de `movie-sample-front` a partir da variável de ambiente `FRONT_URI`, com default `http://localhost:3000`.

#### Scenario: Execução local sem variáveis de ambiente definidas
- **WHEN** o gateway é iniciado sem `SERVER_URI` nem `FRONT_URI` definidas
- **THEN** ele usa `http://localhost:8081` para o server e `http://localhost:3000` para o front

#### Scenario: Execução com variáveis de ambiente sobrescritas
- **WHEN** o gateway é iniciado com `SERVER_URI` e/ou `FRONT_URI` definidas explicitamente (ex: apontando para nomes de serviço de um Docker Compose)
- **THEN** ele usa os valores fornecidos em vez dos defaults, sem exigir alteração de código ou rebuild

### Requirement: Porta e health check do gateway
O gateway SHALL escutar na porta 8080 e SHALL expor um endpoint de health check via Spring Boot Actuator em `/actuator/health`.

#### Scenario: Verificação de saúde do gateway
- **WHEN** uma requisição `GET /actuator/health` é feita ao gateway
- **THEN** o gateway responde com o status de saúde da aplicação

### Requirement: Comportamento padrão para falhas downstream
O gateway SHALL usar o comportamento padrão do Spring Cloud Gateway ao encaminhar requisições para um serviço downstream indisponível, sem lógica customizada de retry, circuit breaker ou fallback.

#### Scenario: Serviço downstream indisponível
- **WHEN** o gateway roteia uma requisição para `movie-sample-server` ou `movie-sample-front` e o serviço de destino está indisponível
- **THEN** o gateway propaga o erro resultante sem aplicar nenhuma lógica de resiliência customizada

### Requirement: Imagem Docker do gateway
O repositório `movie-sample-gateway` SHALL conter um Dockerfile que produz uma imagem executável da aplicação a partir de um build multi-stage (build via Gradle, runtime em uma imagem leve).

#### Scenario: Build da imagem Docker do gateway
- **WHEN** o Dockerfile do `movie-sample-gateway` é construído
- **THEN** o resultado é uma imagem capaz de executar a aplicação do gateway, pronta para ser referenciada pelo `docker-compose.yml` do `movie-sample-ai`
