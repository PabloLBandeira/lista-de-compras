# Especificação de Arquitetura 00 - TaskFlow MVC

## 1. Visão Geral da Arquitetura

Sistema web MVC com Rails 8.1.1 + Hotwire (Turbo/Stimulus) seguindo padrões de SPA (Single-Page Application) com HTML servidor. A experiência mobile é entregue via PWA (Progressive Web App), utilizando manifest e service worker já configurados, sem necessidade de app nativo ou framework externo.

## 2. Estrutura de Diretórios do projeto
O diretório raiz deve conter o projeto em Rails e, no mesmo nível hierárquico, o diretório Spec, este deve conter as especificações para a criação dos códigos de toda a aplicação.

```
lista-de-compras/
  ├── app/
  ├── controllers/
  │   ├── web/                    # Controllers para views HTML (Turbo)
  │   └── api/v1/                 # Controllers para API externa (opcional)
  ├── models/
  │   ├── concerns/               # Modules compartilhados
  │   └── [domain_models]         # Models do domínio
  ├── views/
  │   ├── layouts/                # Layouts principais
  │   ├── components/             # Partials reutilizáveis (Componentes Turbo)
  │   ├── shared/                 # Partials compartilhados
  │   └── [resource]/             # Views por recurso (index, show, edit, _form, etc.)
  ├── javascript/
  │   ├── controllers/            # Stimulus controllers
  │   ├── channels/               # ActionCable (se necessário)
  │   └── application.js          # Entry point
  ├── assets/
  │   ├── stylesheets/            # Bootstrap 5.1 via gem
  │   └── images/
  ├── helpers/                    # View helpers
  ├── mailers/                    # Mailers
  └── jobs/                       # Active Job

  config/
  ├── routes.rb                   # Rotas web + API namespaced
  ├── locales/                    # I18n pt-BR
  └── initializers/               # Configurações

  spec/
  ├── models/
  ├── controllers/
  ├── requests/                   # Testes de integração
  ├── system/                     # System tests (E2E)
  └── features/                   # Capybara + Turbo tests

  public/                         # Assets compilados
  ```

## 3. Padrões MVC Específicos

### Model (ActiveRecord)

- Validações em português nas mensagens de erro
- Scopes nomeados em inglês para convenção técnica
- Callbacks somente quando necessário
- Business logic em service objects quando complexa
- Relacionamentos com métodos bem documentados

### View (ERB + Turbo)

- Layouts responsivos com Bootstrap 5.1
- Partials seguindo Atomic Design adaptado:
  - **Átomos**: `_button.html.erb`, `_input.html.erb`, `_badge.html.erb`
  - **Moléculas**: `_form.html.erb`, `_card.html.erb`, `_search_bar.html.erb`
  - **Organismos**: `_navbar.html.erb`, `_sidebar.html.erb`, `_modal.html.erb`
- Stimulus controllers para interatividade
- Turbo Frames para atualizações parciais

### Controller (ActionController)

- Actions RESTful padrão (index, show, new, create, edit, update, destroy)
- Strong parameters em todos os endpoints
- Flash messages em português
- Turbo Stream responses para ações AJAX
- Separação clara entre web e API controllers

## 4. Fluxo de Dados Turbo

```
Browser
  ↓
Turbo Drive (intercepta navegação)
  ↓
Rails Controller
  ↓
Renderiza HTML Response
  ↓
Turbo Frame Update (atualização parcial)
  ↓
Stimulus Controller (interatividade cliente)
  ↓ (se necessário)
Fetch → API → JSON → DOM Update
```

## 5. API para Mobile (Fase 2)

- Namespace `/api/v1/` - Versionamento de API
- Serialização com `fast_jsonapi` - Segue padrão JSON:API
- Autenticação JWT (gem `jwt`)
- Rate limiting (gem `rack-attack`)
- Documentação OpenAPI com `rswag`
- CORS habilitado para clientes mobile
- Paginação, sorting e filtering consistentes

## 6. Configurações Técnicas

### Gemfile Essentials

```ruby
gem 'rails', '~> 8.1.1'
gem 'hotwire-rails'              # Turbo + Stimulus
gem 'bootstrap', '~> 5.1'        # CSS framework
gem 'devise'                     # Autenticação web
gem 'jwt'                        # Autenticação API
gem 'pg'                         # PostgreSQL
gem 'fast_jsonapi'               # Serialização
gem 'rspec-rails'                # Testing
gem 'factory_bot_rails'          # Test factories
gem 'kaminari'                   # Paginação
gem 'sidekiq'                    # Background jobs (opcional)
```

### bootstrap.config.js

```javascript
// bootstrap.config.js
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

## 7. Convenções de Nomenclatura

| Componente | Padrão | Exemplo |
|---|---|---|
| Controller | Plural | TasksController |
| Model | Singular | Task |
| View directory | Plural | app/views/tasks/ |
| Partial | _singular | _form.html.erb |
| Stimulus controller | [feature]_controller.js | task_controller.js |
| Test file | [model]_spec.rb | task_spec.rb |
| Route | Plural RESTful | resources :tasks |
| I18n key | pt-BR | pt-BR.yml |

## 8. Decisões de Design

### Client-side vs Server-side

| Recurso | Abordagem | Justificativa |
|---|---|---|
| Listas paginadas | Turbo Frames | Progressive enhancement, SEO-friendly |
| Forms complexos | Stimulus + Fetch | Validação cliente + servidor |
| Notificações tempo real | Turbo Streams | Atualizações instantâneas sem reload |
| Uploads arquivo | Stimulus + Active Storage | Progresso visual nativo |
| Modais | Turbo Frames | Contêudo dinâmico sem JavaScript obrigatório |

### Performance

- **Caching**: rails cache para dados estáticos
- **Paginação**: kaminari com cursor-based quando necessário
- **Background Jobs**: sidekiq para tarefas longas (envio email, reports)
- **Asset Pipeline**: esbuild com importmaps moderno
- **Preload**: estratégia de preload para recursos críticos

## 9. Segurança

- CSRF protection ativado por padrão
- Strong parameters em todos os controllers
- Validação em modelo + controller
- Password hashing com bcrypt (Devise)
- JWT com expiração configurável
- Rate limiting por IP/usuário
- SQL injection prevention via ActiveRecord

## 10. Testes - Pirâmide TDD

### Distribuição obrigatória:

- **70% Unitários**: Models, Services, Helpers (RSpec)
- **20% Integração**: Controllers, Requests, Turbo Frames (RSpec + request specs)
- **10% E2E**: Fluxos críticos (System tests com Capybara)

### Estrutura de testes

```ruby
spec/
├── models/
│   ├── task_spec.rb
│   └── user_spec.rb
├── controllers/
│   └── tasks_controller_spec.rb
├── requests/
│   ├── api/
│   │   └── v1/tasks_spec.rb
│   └── web/
│       └── tasks_spec.rb
├── system/
│   ├── tasks_spec.rb          # E2E com Capybara
│   └── user_auth_spec.rb
├── features/
│   └── turbo_frame_updates_spec.rb
└── factories/
    └── task_factory.rb
```

## 11. Internacionalização

- Locale padrão: `pt-BR` (português brasileiro)
- Arquivo: `config/locales/pt-BR.yml`
- Validações de modelo: mensagens em português
- Flash messages: textos em português
- Helpers para formatação de data/hora

## 12. Integração Web + Mobile

```
Desktop User → Turbo HTML → Rails Web Stack
                            ↓ (compartilha banco de dados)
Mobile User → JSON:API ← Rails API Stack

Ambos usam mesmos Models (ActiveRecord)
API usa serializers para formato JSON:API
Web usa views para HTML
```

## 13. Deployment

- **Containerização**: Docker + docker-compose
- **CI/CD**: GitHub Actions
- **Ambiente**: staging + production
- **Database**: PostgreSQL com migrations Rails
- **Assets**: Compilação via Asset Pipeline
- **Env vars**: Configuração por arquivo .env

## 14. Logging e Observabilidade

- Logs estruturados em JSON
- Levels: DEBUG, INFO, WARN, ERROR
- Rastreamento de requisições com correlation IDs
- Monitoramento de performance (optional: New Relic, Datadog)
- Error tracking (optional: Sentry)

---

Versão: 1.0.0
Status: Aprovado
Criado em: 16 de janeiro de 2026
Última Revisão: 16 de janeiro de 2026
Alinhado com: TaskFlow Constitution v1.0.0
