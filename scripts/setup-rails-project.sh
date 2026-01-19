#!/bin/bash

# Verificar se o Ruby está instalado
if ! command -v ruby &> /dev/null
then
    echo "Ruby não está instalado. Instalando Ruby..."
    sudo apt-get update && sudo apt-get install -y ruby-full
fi

# Verificar a versão do Ruby
RUBY_VERSION=$(ruby -v | awk '{print $2}')
REQUIRED_RUBY_VERSION="3.4.8"
if [ "$RUBY_VERSION" != "$REQUIRED_RUBY_VERSION" ]; then
    echo "Versão do Ruby instalada: $RUBY_VERSION. Atualizando para $REQUIRED_RUBY_VERSION..."
    # Atualizar Ruby (exemplo usando rbenv, ajuste conforme necessário)
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-installer | bash
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    rbenv install $REQUIRED_RUBY_VERSION
    rbenv global $REQUIRED_RUBY_VERSION
fi

echo "Ruby está instalado e atualizado para a versão $REQUIRED_RUBY_VERSION."

# Verificar se o Rails está instalado
if ! gem list rails -i > /dev/null
then
    echo "Rails não está instalado. Instalando Rails..."
    gem install rails -v 8.1.1
fi

# Verificar a versão do Rails
RAILS_VERSION=$(rails -v | awk '{print $2}')
REQUIRED_RAILS_VERSION="8.1.1"
if [ "$RAILS_VERSION" != "$REQUIRED_RAILS_VERSION" ]; then
    echo "Versão do Rails instalada: $RAILS_VERSION. Atualizando para $REQUIRED_RAILS_VERSION..."
    gem uninstall rails -a -x
    gem install rails -v $REQUIRED_RAILS_VERSION
fi

echo "Rails está instalado e atualizado para a versão $REQUIRED_RAILS_VERSION."

# Inicializar o projeto Rails
PROJECT_NAME="lista-de-compras"
if [ ! -d "$PROJECT_NAME" ]; then
    echo "Criando o projeto Rails no diretório $PROJECT_NAME..."
    rails new $PROJECT_NAME --database=postgresql
    cd $PROJECT_NAME

        # Configurar o banco de dados para uso com Docker
        echo "Configurando o banco de dados para Docker..."
        cat > config/database.yml <<EOL
# PostgreSQL config para Docker

default: &default
    adapter: postgresql
    encoding: unicode
    pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
    username: postgres
    password: password
    host: db

development:
    <<: *default
    database: lista_de_compras_development

test:
    <<: *default
    database: lista_de_compras_test

production:
    <<: *default
    database: lista_de_compras_production
EOL

        rails db:create

        echo "Projeto Rails inicializado com sucesso no diretório $PROJECT_NAME."
else
    echo "O diretório $PROJECT_NAME já existe. Certifique-se de que o projeto está configurado corretamente."
fi