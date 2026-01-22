# TaskFlow Constitution

<!-- Sync Impact Report: Initial adoption of TaskFlow governance model -->
<!-- Version Change: Template → 1.0.0 | Date: 2026-01-13 -->
<!-- Principles: 7 core governance principles established for MVC architecture com Rails + PWA -->
<!-- Technology Stack: Rails 8.1.1, PostgreSQL, Hotwire (Turbo+Stimulus), PWA -->
<!-- Governance: Established Constitution-driven development, mandatory spec approval, pair programming on AI-generated code -->

## Core Principles

### I. MVC Layer Separation (NON-NEGOTIABLE)
Cada funcionalidade deve ser implementada em camadas claramente separadas: Model (domínio/dados), View (interface) e Controller (lógica de aplicação). Dependências sempre apontam para dentro - View → Controller → Model.

### II. Server-Rendered SPA Experience
Turbo Drive + Turbo Frames para experiência SPA (Single-Page Application) com HTML servidor. Transições instantâneas sem recarregamento completo. Progressive enhancement obrigatório - funcionalidade básica sem JavaScript.

### III. Mobile via PWA
A experiência mobile será entregue via PWA (Progressive Web App), utilizando a mesma base Rails/Hotwire. O manifest e o service worker já estão configurados para permitir instalação e uso offline, sem necessidade de app nativo ou framework externo.

### IV. Test Pyramid Enforcement
TDD obrigatório seguindo pirâmide de testes: 70% unitários (Models/Rails), 20% integração (Controllers/Turbo), 10% E2E (fluxos críticos). Tests escritos → Aprovados → Falham → Implementação.

### V. API-First Design (se necessário)
Se houver necessidade de integração externa, o backend pode expor contrato JSON:API. Para o uso mobile via PWA, a experiência é baseada em HTML server-rendered e Hotwire.

### VI. Rails Convention Over Configuration
Seguir convenções Rails 8.1.1 rigorosamente. Hotwire (Turbo + Stimulus) como stack padrão frontend. Asset pipeline moderno com importmaps ou esbuild.

### VII. Portuguese-First Documentation (NON-NEGOTIABLE)
Todas as especificações, documentações técnicas, comentários de código e commits devem ser escritos em português brasileiro (pt-BR). Nomenclatura de código (variáveis, métodos, classes) pode seguir convenções técnicas em inglês, mas toda documentação de negócio e comunicação técnica deve ser em português.

## Technology Stack & Constraints

- **Web Frontend**: Turbo (Hotwire) com HTML server-rendered, Stimulus.js para interatividade
- **Backend**: Ruby 3.4.8 com Rails 8.1.1, PostgreSQL com ActiveRecord
- **Mobile**: PWA baseada em Rails/Hotwire, manifest e service worker configurados
- **Estilo**: Bootstrap CSS via Rails gem, Design responsivo mobile-first
- **Autenticação**: Devise para web, JWT para API mobile
- **Deploy**: Docker containerização, CI/CD com GitHub Actions

## Development Workflow

1. **Spec Approval**: Cada spec `.specify/03-*.md` deve ser aprovada antes do desenvolvimento
2. **Pair Programming**: Todo código gerado por Copilot deve ser revisado em par por humano
3. **Review Gates**: PRs exigem: todos os testes Rails (RSpec), linting (RuboCop), segurança (Brakeman)
4. **Documentation**: Cada funcionalidade requer: Documentação de componente View, exemplos de uso Turbo, atualização do componente system test
5. **Portuguese Documentation**: Todas as specs (.specify), READMEs, comentários de código e documentação técnica devem ser escritos em português (pt-BR). Commits em português.

## Governance

Esta Constituição supera decisões ad-hoc. Mudanças exigem:

1. Proposta via PR no `.specify/constitution/`
2. Aprovação de 2 maintainers
3. Período de review de 3 dias
4. Plano de migração para breaking changes

Use `02-guardrails.md` para instruções específicas ao Copilot durante o desenvolvimento.

Versão: 1.0.0
Status: Aprovado
Criado em: 16 de janeiro de 2026
Última Revisão: 16 de janeiro de 2026
Alinhado com: TaskFlow Constitution v1.0.0
