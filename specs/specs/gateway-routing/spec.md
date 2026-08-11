# gateway-routing

## Purpose

Roteamento do `movie-sample-gateway`: as rotas explícitas (por path e
método) que direcionam requisições para `movie-sample-server` ou
`movie-sample-front`, e a ausência de fallback para requisições fora da
allowlist.

## Requirements

### Requirement: Rotas explícitas para a API

O gateway SHALL rotear `GET /api/movies` e `POST /api/movies` para
`movie-sample-server`, e SHALL rotear `GET /api/movies/{id}`,
`PUT /api/movies/{id}` e `DELETE /api/movies/{id}` para
`movie-sample-server`, usando predicates de Path e de Method combinados
(não um prefixo genérico).

#### Scenario: Requisição válida para a coleção de filmes

- **WHEN** uma requisição `GET /api/movies` ou `POST /api/movies` chega ao
  gateway
- **THEN** ela é roteada para `movie-sample-server`

#### Scenario: Requisição válida para um filme específico

- **WHEN** uma requisição `GET`, `PUT` ou `DELETE` em `/api/movies/{id}`
  chega ao gateway
- **THEN** ela é roteada para `movie-sample-server`

#### Scenario: Método não permitido para uma rota da API

- **WHEN** uma requisição com um método não declarado para aquele path
  chega ao gateway (ex: `PATCH /api/movies/{id}`)
- **THEN** ela não bate em nenhum predicate de rota da API e não é roteada
  para `movie-sample-server`

### Requirement: Rotas explícitas para as páginas do front

O gateway SHALL rotear `GET /` e `GET /movies` para `movie-sample-front`. O
gateway SHALL rotear `GET /movies/{id}` e `POST /movies/{id}` para
`movie-sample-front`, e SHALL rotear `GET /movies/new` e `POST /movies/new`
para `movie-sample-front` — o método `POST` é necessário nessas duas
páginas porque as Server Actions do Next.js (edição inline e remoção em
`/movies/{id}`; cadastro em `/movies/new`) são invocadas via `POST` para a
própria URL da página, não para `/api/**`.

#### Scenario: Requisição GET para uma página conhecida do front

- **WHEN** uma requisição `GET` chega ao gateway em `/`, `/movies`,
  `/movies/{id}` ou `/movies/new`
- **THEN** ela é roteada para `movie-sample-front`

#### Scenario: Invocação de Server Action em /movies/{id} ou /movies/new

- **WHEN** uma requisição `POST` chega ao gateway em `/movies/{id}` ou
  `/movies/new` (invocação de Server Action feita pelo browser)
- **THEN** ela é roteada para `movie-sample-front`

#### Scenario: Método não permitido nas páginas do front

- **WHEN** uma requisição com um método não declarado para aquele path
  chega ao gateway (ex: `DELETE /movies/{id}`)
- **THEN** ela não bate em nenhum predicate de rota do front e não é
  roteada para `movie-sample-front`

### Requirement: Wildcard restrito aos assets estáticos do Next.js

O gateway SHALL rotear qualquer requisição sob `/_next/**` para
`movie-sample-front`, sendo esta a única rota que usa predicate de wildcard
em todo o gateway.

#### Scenario: Requisição de asset estático do Next.js

- **WHEN** uma requisição `GET` chega ao gateway em um path sob `/_next/`
- **THEN** ela é roteada para `movie-sample-front`, independentemente do
  path exato após `/_next/`

### Requirement: Ausência de rota para requisições fora da allowlist

O gateway SHALL NOT rotear nenhuma requisição que não bata em nenhum dos
predicates explícitos definidos (API ou páginas do front) nem no predicate
de wildcard de `/_next/**`.

#### Scenario: Requisição para um path não declarado

- **WHEN** uma requisição chega ao gateway para um path que não corresponde
  a nenhuma rota declarada (ex: `GET /api/movies/{id}/reviews`, ou
  `GET /admin`)
- **THEN** o gateway não a roteia para nenhum serviço downstream, seguindo
  o comportamento padrão do Spring Cloud Gateway para rota não encontrada
