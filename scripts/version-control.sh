#!/bin/bash

# Verificar se o diretório já é um repositório Git
if [ ! -d ".git" ]; then
    echo "Iniciando repositório Git..."
    git init
    echo "# lista-de-compras" >> README.md
    git add README.md
    git commit -m "docs: criação do arquivo README.md"
    git branch -M main
    git remote add origin https://github.com/BandeiraPablo/lista-de-compras.git
    git push -u origin main
else
    echo "Repositório Git já inicializado."
fi

# Verificar o status de mudanças no projeto
CHANGES=$(git status --porcelain)
if [ -z "$CHANGES" ]; then
    echo "Nenhuma mudança detectada no projeto."
    exit 0
fi

# Adicionar, commitar e enviar arquivos em ordem cronológica
for FILE in $(find . -type f -not -path '*/\.git/*' -printf '%T@ %p\n' | sort -n | cut -d' ' -f2-)
do
    # Criar uma nova branch para o arquivo
    BRANCH_NAME="feature/$(basename "$FILE" | sed 's/\./-/g')"
    git checkout -b "$BRANCH_NAME"

    # Adicionar o arquivo
    git add "$FILE"

    # Solicitar mensagem de commit ao usuário
    echo "Digite a mensagem de commit para o arquivo $(basename "$FILE"):"
    read COMMIT_MESSAGE

    # Criar o commit
    git commit -m "$COMMIT_MESSAGE"

    # Fazer o push da branch
    git push -u origin "$BRANCH_NAME"

    # Fazer o merge com a branch main
    git checkout main
    git merge --no-ff "$BRANCH_NAME" -m "merge: integrando $(basename "$FILE") na main"
    git push origin main

    # Deletar a branch temporária
    git branch -d "$BRANCH_NAME"
done

echo "Versionamento concluído com sucesso."