## 1. Estrutura e build do repositório

- [x] 1.1 Criar a estrutura de diretórios do repositório `movie-sample-gateway`: `.claude/`, `.ai/agents/`, `.ai/skills/`, `src/main/java/...`, `src/main/resources/`, `src/test/java/...`
- [x] 1.2 Configurar `build.gradle` (Groovy DSL) e `gradle/libs.versions.toml` com Java 25, Spring Boot 4.1.0, Spring Cloud Gateway (reativo/WebFlux), Actuator
- [x] 1.3 Configurar `settings.gradle` (módulo único)

## 2. Governança do repositório (standalone)

- [x] 2.1 Escrever `movie-sample-gateway/AGENTS.md` com a stack de build, o papel do gateway como fachada única, e a convenção de manter a allowlist de rotas atualizada manualmente
- [x] 2.2 Escrever `movie-sample-gateway/CLAUDE.md` redirecionando para `movie-sample-gateway/AGENTS.md`
- [x] 2.3 Criar `.ai/skills/` e `.ai/agents/` com placeholder mínimo, e os symlinks `.claude/skills` → `.ai/skills` e `.claude/agents` → `.ai/agents`

## 3. Roteamento

- [x] 3.1 Configurar em `application.yml` a rota `GET, POST /api/movies` → `${SERVER_URI}`
- [x] 3.2 Configurar em `application.yml` a rota `GET, PUT, DELETE /api/movies/{id}` → `${SERVER_URI}`
- [x] 3.3 Configurar as rotas `GET /`, `GET /movies`, `GET /movies/{id}`, `GET /movies/new` → `${FRONT_URI}`
- [x] 3.4 Configurar a rota `GET /_next/**` → `${FRONT_URI}` (única rota com wildcard)
- [x] 3.5 Escrever testes de roteamento (ex: `WebTestClient` contra destinos de teste/stub) cobrindo: requisição válida por rota, método não permitido não roteado, path fora da allowlist não roteado, wildcard de `/_next/**` cobrindo qualquer sub-path

## 4. Operação

- [x] 4.1 Configurar `SERVER_URI` (default `http://localhost:8081`) e `FRONT_URI` (default `http://localhost:3000`) como propriedades configuráveis via variável de ambiente
- [x] 4.2 Habilitar Spring Boot Actuator expondo `/actuator/health`
- [x] 4.3 Configurar a aplicação para escutar na porta 8080

## 5. Docker

- [x] 5.1 Criar `Dockerfile` multi-stage (build via Gradle, runtime em imagem leve)
- [x] 5.2 Atualizar o comentário/placeholder do serviço `gateway` em `movie-sample-ai/docker-compose.yml`, confirmando que o `build.context: ../movie-sample-gateway` agora aponta para um repositório com Dockerfile válido

## 6. Validação

- [x] 6.1 Rodar a suíte de testes de roteamento e confirmar que todos passam
- [x] 6.2 Validar manualmente `GET /actuator/health` retorna sucesso com a aplicação rodando localmente (usando os defaults de `SERVER_URI`/`FRONT_URI`)
- [x] 6.3 Validar as specs desta mudança com `openspec validate` antes de considerar pronta para archive

## 7. Correção pós-validação (encontrada via UI real no navegador)

- [x] 7.1 Testando a edição de filme pela UI real (não só `curl` contra `/api/movies`), a Server Action do Next.js (`POST` para a própria URL de `/movies/{id}` e `/movies/new`) não era roteada — essas rotas só permitiam `GET`. Corrigido: `Method=GET,POST` para `front-movie-detail` e `front-movie-new` em `application.yml`, com testes novos em `GatewayRoutingTest` cobrindo o `POST` permitido e outros métodos continuando bloqueados
