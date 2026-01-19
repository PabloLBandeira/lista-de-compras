#!/bin/bash

# Verificar se o Docker está instalado
if ! command -v docker &> /dev/null
then
    echo "Docker não está instalado. Por favor, instale o Docker antes de continuar."
    exit 1
fi

# Verificar a versão do Docker
DOCKER_VERSION=$(docker --version)
echo "Versão do Docker instalada: $DOCKER_VERSION"

# Testar se o Docker está funcionando
if ! docker info &> /dev/null
then
    echo "Docker não está funcionando corretamente. Verifique o serviço do Docker."
    exit 1
fi

echo "Docker está instalado e funcionando corretamente."

# Definir diretório do projeto Rails
PROJECT_DIR="./lista-de-compras"

# Criar diretório se não existir
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Diretório do projeto Rails '$PROJECT_DIR' não encontrado. Por favor, inicialize o projeto Rails antes de prosseguir."
    exit 1
fi

# Criar arquivos necessários para a dockerização dentro do projeto Rails
DOCKERFILE_PATH="$PROJECT_DIR/Dockerfile"
DOCKER_COMPOSE_PATH="$PROJECT_DIR/docker-compose.yml"

# Criar Dockerfile
cat <<EOL > $DOCKERFILE_PATH
FROM ruby:3.4.8
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app
EOL

echo "Dockerfile criado em $DOCKERFILE_PATH"

# Criar docker-compose.yml
cat <<EOL > $DOCKER_COMPOSE_PATH
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
EOL

echo "Arquivo docker-compose.yml criado em $DOCKER_COMPOSE_PATH"

# Construir e iniciar os containers
echo "Construindo e iniciando os containers..."
cd "$PROJECT_DIR"
docker-compose up --build

echo "Ambiente Docker configurado e pronto para uso."