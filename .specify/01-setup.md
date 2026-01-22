## Observação sobre Logout Seguro

Para garantir que o logout funcione em todos os ambientes (inclusive sem JavaScript), utilize sempre button_to para o botão de sair, garantindo o método DELETE.

Se utilizar Devise com o módulo :rememberable, certifique-se de que a migration de User inclui a coluna remember_created_at:datetime.

# Blueprint de Configuração do Projeto (Web e PWA)

## Verificação de Dependências

1. **Docker**:
   - Verificar se o Docker está instalado:
     ```bash
     docker --version
     ```
   - Caso não esteja instalado, seguir as instruções de instalação para o sistema operacional Linux.

2. **Ruby**:
   - Verificar se o Ruby está instalado:
     ```bash
     ruby --version
     ```
   - Caso não esteja instalado, instalar utilizando o gerenciador de pacotes apropriado (ex.: `rbenv` ou `rvm`).

3. **Rails**:
   - Verificar se o Rails está instalado:
     ```bash
     rails --version
     ```
   - Caso não esteja instalado, instalar com o comando:
     ```bash
     gem install rails -v 8.1.1
     ```

4. **Outras Dependências**:
   - PostgreSQL:
     ```bash
     psql --version
     ```
   - Caso não esteja instalado, instalar utilizando o gerenciador de pacotes do sistema.


## Dockerização da Aplicação e Ativação do PWA

1. Criar um arquivo `Dockerfile`:
   ```dockerfile
   FROM ruby:3.4.8
   RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
   WORKDIR /app
   COPY Gemfile /app/Gemfile
   COPY Gemfile.lock /app/Gemfile.lock
   RUN bundle install
   COPY . /app
   ```

2. Criar um arquivo `docker-compose.yml`:
   ```yaml
   version: '3.9'
   services:
     db:
       image: postgres
       environment:
         POSTGRES_USER: postgres
         POSTGRES_PASSWORD: password
     web:
       build: .
       command: bash -c "rm -f tmp/pids/server.pid && rails server -b '0.0.0.0'"
       volumes:
         - .:/app
       ports:
         - "3000:3000"
       depends_on:
         - db
   ```

3. Construir e iniciar os containers:
   4. Para ativar o PWA, certifique-se de que as rotas para manifest e service worker estão habilitadas em config/routes.rb e que o manifest está referenciado em application.html.erb.
   ```bash
   docker-compose up --build
   ```

## Criação do Projeto Rails

1. Inicializar um novo projeto Rails no diretório especificado:
   ```bash
   rails new lista-de-compras --database=postgresql
   ```

2. Configurar o banco de dados:
   ```bash
   rails db:create
   ```

## Atualização e Instalação de Gems

1. Verificar o arquivo `Gemfile` e adicionar as gems necessárias:
   ```ruby
   gem 'devise'
   gem 'hotwire-rails'
   gem 'rspec-rails', group: [:development, :test]
   ```

2. Instalar as gems:
   ```bash
   bundle install
   ```

3. Configurar as gems:
   - Devise:
     ```bash
     rails generate devise:install
     ```
   - RSpec:
     ```bash
     rails generate rspec:install
     ```

## Verificações Finais

1. Verificar se o servidor está funcionando:
   ```bash
   rails server
   ```

2. Testar a aplicação acessando `http://localhost:3000` no navegador.

3. Garantir que todos os testes estão passando:
   ```bash
   rspec
   ```
   
Versão: 1.0.0
Status: Aprovado
Criado em: 16 de janeiro de 2026
Última Revisão: 16 de janeiro de 2026
Alinhado com: TaskFlow Constitution v1.0.0