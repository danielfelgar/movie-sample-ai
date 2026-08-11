## ADDED Requirements

### Requirement: Página de listagem de filmes
O front SHALL expor a página `/movies`, exibindo a lista completa de filmes obtida via `GET /api/movies` através do gateway.

#### Scenario: Listagem com filmes cadastrados
- **WHEN** a página `/movies` é acessada e existem filmes cadastrados
- **THEN** a página exibe todos os filmes retornados pela API

#### Scenario: Listagem sem filmes cadastrados
- **WHEN** a página `/movies` é acessada e não existe nenhum filme cadastrado
- **THEN** a página exibe um estado vazio, sem erro

### Requirement: Página de detalhe com edição inline
O front SHALL expor a página `/movies/{id}`, exibindo os dados do filme obtido via `GET /api/movies/{id}` através do gateway, com um controle que habilita a edição dos campos no lugar (sem navegar para outra rota). A submissão da edição SHALL chamar `PUT /api/movies/{id}` através do gateway via Server Action.

#### Scenario: Visualização de um filme existente
- **WHEN** a página `/movies/{id}` é acessada com o `id` de um filme existente
- **THEN** a página exibe os dados do filme em modo de leitura

#### Scenario: Acionamento da edição inline
- **WHEN** o usuário aciona o controle de edição na página de detalhe
- **THEN** os campos do filme tornam-se editáveis na mesma página, sem navegação para outra rota

#### Scenario: Submissão de edição válida
- **WHEN** o usuário edita os campos com dados válidos e submete
- **THEN** a Server Action chama `PUT /api/movies/{id}` através do gateway, e a página passa a exibir os dados atualizados

#### Scenario: Filme inexistente
- **WHEN** a página `/movies/{id}` é acessada com um `id` que não corresponde a nenhum filme cadastrado
- **THEN** a página exibe um estado de "não encontrado"

### Requirement: Página de cadastro de filme
O front SHALL expor a página `/movies/new`, com um formulário de cadastro cuja submissão chama `POST /api/movies` através do gateway via Server Action.

#### Scenario: Cadastro bem-sucedido
- **WHEN** o usuário preenche o formulário de `/movies/new` com dados válidos e submete
- **THEN** a Server Action chama `POST /api/movies` através do gateway, e o usuário é levado a visualizar o filme recém-criado

### Requirement: Comunicação sempre através do gateway
Toda comunicação do front com a API SHALL passar pelo `movie-sample-gateway`, inclusive chamadas feitas em Server Components/SSR — o front SHALL NOT chamar o `movie-sample-server` diretamente em nenhum cenário.

#### Scenario: Requisição feita durante renderização no servidor (SSR)
- **WHEN** uma página do front busca dados da API durante a renderização no servidor
- **THEN** essa requisição é feita contra o `movie-sample-gateway`, não diretamente contra o `movie-sample-server`

### Requirement: Server Actions funcionam atrás do gateway
As Server Actions do front (criar, editar, remover) SHALL funcionar quando o front é acessado através do `movie-sample-gateway`, mesmo com a origem pública (a do gateway) sendo diferente do host interno em que o Next.js roda. O front SHALL configurar `experimental.serverActions.allowedOrigins` (`next.config.ts`) com a origem pública do gateway.

#### Scenario: Invocação de Server Action através do gateway
- **WHEN** o usuário submete um formulário de criação, edição ou remoção estando na aplicação acessada via `movie-sample-gateway`
- **THEN** a Server Action é aceita e executada (não é rejeitada pela checagem de CSRF do Next.js por divergência entre `Origin` e o host interno)

### Requirement: Validação client-side espelhando o contrato de domínio
Os formulários de cadastro e edição SHALL validar os campos no client usando as mesmas regras definidas em `movie-domain-spec` (título obrigatório até 255 caracteres, ano entre 1888 e o ano atual + 10, gênero e diretor obrigatórios, sinopse opcional, duração entre 1 e 999), exibindo feedback antes da submissão.

#### Scenario: Submissão com dado inválido
- **WHEN** o usuário tenta submeter um formulário (cadastro ou edição) com um campo que viola alguma regra de `movie-domain-spec` (ex: ano fora do intervalo permitido)
- **THEN** o formulário exibe o erro de validação correspondente e não chama a Server Action
