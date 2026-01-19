# Lista de Compras

Aplicação web para gerenciamento pessoal de lista de compras, desenvolvida em Ruby on Rails 8, com autenticação Devise, interface responsiva em Bootstrap 5 e Docker para fácil deploy.

## Funcionalidades

- Cadastro e login de usuários (Devise)
- Adição de itens à lista "A Comprar"
- Marcação de itens como comprados e desmarcação
- Exclusão em lote de itens comprados
- Exclusão de múltiplos itens selecionados
- Checkbox mestre para seleção rápida
- Interface 100% em português brasileiro
- Layout responsivo e moderno (Bootstrap)
- Logout seguro (compatível com ambientes sem JS)
- Deploy e desenvolvimento via Docker

## Tecnologias Utilizadas

- Ruby 3.4.8
- Rails 8.1.2
- PostgreSQL
- Devise (autenticação)
- Bootstrap 5 (UI)
- Hotwire (Turbo)
- Importmap (JS)
- Docker e docker-compose

## Como rodar localmente

1. **Clone o repositório:**
   ```sh
   git clone https://github.com/PabloLBandeira/lista-de-compras.git
   cd lista-de-compras
   ```
2. **Suba os containers Docker:**
   ```sh
   docker-compose up --build
   ```
3. **Acesse no navegador:**
   - http://localhost:3000

## Estrutura do Projeto

- `app/` — Código principal (models, controllers, views)
- `config/` — Configurações do Rails, rotas, inicializadores
- `db/` — Migrations e seeds
- `public/` — Assets públicos
- `specify/` — Especificações e documentação técnica
- `scripts/` — Scripts utilitários

## Especificações e Documentação

Todas as regras de negócio, arquitetura, fluxos e requisitos estão documentados em `/specify/`.
- Arquitetura MVC rigorosa
- Testes automatizados (RSpec)
- Documentação em português brasileiro

## Contribuição

1. Fork este repositório
2. Crie uma branch: `git checkout -b minha-feature`
3. Commit suas alterações: `git commit -m 'feat: minha nova feature'`
4. Push para sua branch: `git push origin minha-feature`
5. Abra um Pull Request

## Licença

Este projeto está sob a licença MIT.

---

Desenvolvido por Pablo L. Bandeira e colaboradores.
