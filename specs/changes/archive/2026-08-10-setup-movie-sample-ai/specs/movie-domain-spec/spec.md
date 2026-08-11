## ADDED Requirements

### Requirement: Identidade do Movie
O domínio `Movie` SHALL ter um identificador interno numérico (`id`, `Long`, autoincrement, gerado pelo banco de dados) não exposto em nenhuma API, e um identificador público (`UUID`, gerado na criação do registro) exposto nas APIs como o campo `id`.

#### Scenario: Um novo Movie é criado
- **WHEN** um novo `Movie` é persistido
- **THEN** ele recebe um `id` interno (`Long`) gerado pelo banco e um `UUID` gerado no momento da criação, sendo o `UUID` o único identificador exposto externamente

### Requirement: Campos descritivos do Movie
O domínio `Movie` SHALL definir os seguintes campos: `titulo` (texto, obrigatório, até 255 caracteres), `ano` (inteiro, obrigatório, entre 1888 e o ano atual + 10), `genero` (texto simples, obrigatório, até 100 caracteres), `diretor` (texto, obrigatório, até 255 caracteres), `sinopse` (texto longo, opcional, sem limite de tamanho), `duracao` (inteiro, obrigatório, entre 1 e 999, representando minutos).

#### Scenario: Movie válido é aceito
- **WHEN** um `Movie` é submetido com todos os campos obrigatórios preenchidos e dentro dos limites definidos
- **THEN** o `Movie` é aceito como válido

#### Scenario: Ano fora do intervalo permitido é rejeitado
- **WHEN** um `Movie` é submetido com `ano` menor que 1888 ou maior que o ano atual + 10
- **THEN** o `Movie` é rejeitado como inválido

#### Scenario: Título ausente é rejeitado
- **WHEN** um `Movie` é submetido sem `titulo` ou com `titulo` vazio
- **THEN** o `Movie` é rejeitado como inválido

#### Scenario: Duração fora do intervalo permitido é rejeitada
- **WHEN** um `Movie` é submetido com `duracao` menor ou igual a 0, ou maior que 999
- **THEN** o `Movie` é rejeitado como inválido

#### Scenario: Sinopse ausente é aceita
- **WHEN** um `Movie` é submetido sem o campo `sinopse`
- **THEN** o `Movie` continua sendo válido, já que `sinopse` é opcional

### Requirement: Contrato compartilhado entre server e front
O modelo `Movie` definido nesta spec SHALL ser a fonte única de verdade do contrato de dados usado tanto pela implementação da API (`movie-sample-server`) quanto pela interface (`movie-sample-front`), de modo que ambos implementem os mesmos campos, tipos e regras de validação descritos aqui.

#### Scenario: Implementação de server ou front diverge da spec
- **WHEN** uma mudança futura implementa `movie-sample-server` ou `movie-sample-front` com um campo, tipo ou regra de validação de `Movie` diferente do descrito nesta spec
- **THEN** essa implementação é considerada incorreta em relação ao contrato compartilhado, e a spec (não a implementação) é a referência a ser seguida
