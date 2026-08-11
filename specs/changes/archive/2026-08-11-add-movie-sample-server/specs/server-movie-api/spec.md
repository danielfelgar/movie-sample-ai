## ADDED Requirements

### Requirement: Criar filme
O server SHALL expor `POST /api/movies`, aceitando os campos definidos em `movie-domain-spec`, e SHALL responder `201 Created` com o header `Location` apontando para o recurso criado e o corpo do filme criado (incluindo o `id` público gerado).

#### Scenario: Criação bem-sucedida
- **WHEN** um `POST /api/movies` é enviado com todos os campos obrigatórios válidos
- **THEN** o server responde `201 Created`, com header `Location` e o corpo contendo o filme criado, incluindo seu `id`

#### Scenario: Criação com dados inválidos
- **WHEN** um `POST /api/movies` é enviado violando alguma regra de validação de `movie-domain-spec` (ex: `titulo` vazio, `ano` fora do intervalo permitido)
- **THEN** o server responde com um erro de validação no formato `ProblemDetail`, e o filme não é persistido

### Requirement: Listar filmes
O server SHALL expor `GET /api/movies`, retornando a lista completa de filmes cadastrados, sem paginação.

#### Scenario: Listagem com filmes cadastrados
- **WHEN** um `GET /api/movies` é feito e existem filmes cadastrados
- **THEN** o server responde `200 OK` com a lista completa de filmes

#### Scenario: Listagem sem filmes cadastrados
- **WHEN** um `GET /api/movies` é feito e não existe nenhum filme cadastrado
- **THEN** o server responde `200 OK` com uma lista vazia

### Requirement: Buscar filme por id
O server SHALL expor `GET /api/movies/{id}`, onde `{id}` é o UUID público do filme, retornando o filme correspondente ou um erro `404` se não existir.

#### Scenario: Filme encontrado
- **WHEN** um `GET /api/movies/{id}` é feito com o `id` de um filme existente
- **THEN** o server responde `200 OK` com os dados do filme

#### Scenario: Filme não encontrado
- **WHEN** um `GET /api/movies/{id}` é feito com um `id` que não corresponde a nenhum filme cadastrado
- **THEN** o server responde `404 Not Found` no formato `ProblemDetail`

### Requirement: Atualizar filme
O server SHALL expor `PUT /api/movies/{id}`, substituindo integralmente os dados do filme existente pelos dados enviados, respeitando as mesmas regras de validação da criação, e SHALL responder `200 OK` com o recurso atualizado.

#### Scenario: Atualização bem-sucedida
- **WHEN** um `PUT /api/movies/{id}` é enviado com dados válidos para um filme existente
- **THEN** o server responde `200 OK` com o filme atualizado refletindo os novos dados

#### Scenario: Atualização de filme inexistente
- **WHEN** um `PUT /api/movies/{id}` é enviado para um `id` que não corresponde a nenhum filme cadastrado
- **THEN** o server responde `404 Not Found` no formato `ProblemDetail`

#### Scenario: Atualização com dados inválidos
- **WHEN** um `PUT /api/movies/{id}` é enviado violando alguma regra de validação de `movie-domain-spec`
- **THEN** o server responde com um erro de validação no formato `ProblemDetail`, e o filme existente não é alterado

### Requirement: Remover filme
O server SHALL expor `DELETE /api/movies/{id}`, removendo o filme correspondente e respondendo `204 No Content`.

#### Scenario: Remoção bem-sucedida
- **WHEN** um `DELETE /api/movies/{id}` é feito com o `id` de um filme existente
- **THEN** o server responde `204 No Content` e o filme deixa de existir

#### Scenario: Remoção de filme inexistente
- **WHEN** um `DELETE /api/movies/{id}` é feito com um `id` que não corresponde a nenhum filme cadastrado
- **THEN** o server responde `404 Not Found` no formato `ProblemDetail`

### Requirement: Formato de erro padronizado
Todo erro retornado pela API SHALL usar o formato `ProblemDetail` (RFC 7807).

#### Scenario: Qualquer resposta de erro da API
- **WHEN** qualquer endpoint de `/api/movies` retorna um status de erro (4xx ou 5xx)
- **THEN** o corpo da resposta segue o formato `ProblemDetail`
