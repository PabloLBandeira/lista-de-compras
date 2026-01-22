
# Especificação 03 - Lista de Compras: Visão do Produto (Web e PWA)

## 1. Visão Geral
Aplicação web para gerenciamento pessoal de lista de compras. Permite que usuários cadastrados adicionem itens, marquem-os como comprados e gerenciem suas listas de forma intuitiva e rápida, com uma experiência de página única (SPA). A aplicação pode ser instalada como PWA em dispositivos móveis, sem necessidade de app nativo.

## 2. Requisitos Funcionais

### 2.1. Autenticação
- **RF01:** Sistema de login com email e senha.
- **RF02:** Cadastro de novo usuário (nome, email, senha).
- **RF03:** Ao fazer cadastro ser redirecionado automaticamente para a home [lista de compras].
- **RF04:** Logout seguro (deve funcionar mesmo sem JavaScript, utilizando button_to para garantir método DELETE, conforme padrão Rails 7+ com importmap).
- **RF05:** Sessão persistente (utilizando Devise com módulo :rememberable, exigindo a coluna remember_created_at no banco).
**Nota:** A interface de logout deve usar button_to (formulário DELETE) para garantir funcionamento em ambientes sem JavaScript, conforme padrão Rails moderno.

### 2.2. Gerenciamento de Itens
- **RF05:** Adicionar item à lista principal ("A Comprar").
- **RF06:** Visualizar lista de itens "a comprar".
- **RF07:** Marcar item como comprado (move automaticamente para lista "comprados").
- **RF08:** Desmarcar item (retorna para lista "a comprar").
- **RF09:** Excluir todos os itens comprados em lote.
- **RF10:** Excluir múltiplos itens selecionados da lista principal.
- **RF11:** "Checkbox mestre" para selecionar/deselecionar todos os itens da lista principal de uma vez.

## 3. Telas e Componentes (Wireframes)

### 3.1. Tela de Login (`/login`)

[Logo/App Name]
┌─────────────────────────────┐
│ FAÇA LOGIN │
├─────────────────────────────┤
│ Email: [] │
│ Senha: [] │
│ │
│ [ENTRAR] │
│ │
│ Não tem conta? Cadastre-se │
└─────────────────────────────┘

**Comportamento:**
- Validação em tempo real dos campos.
- Mensagem de erro clara para credenciais inválidas.
- Link para tela de cadastro.

### 3.2. Tela de Cadastro (`/cadastro`)
[Logo/App Name]
┌─────────────────────────────┐
│ CADASTRE-SE │
├─────────────────────────────┤
│ Nome: [___________] │
│ Email: [________] │
│ Senha: [______] │
│ Confirmar Senha: [] │
│ │
│ [CADASTRAR] │
│ │
│ Já tem conta? Faça login │
└─────────────────────────────┘

**Comportamento:**
- Validação: nome (mín. 2 caracteres), email válido, senha (mín. 6 caracteres).
- Confirmação de senha deve coincidir.
- Redirecionamento automático para a lista após cadastro.

### 3.3. Tela Principal (`/`)
┌─────────────────────────────────────────────────────────┐
│ [Logo] Minha Lista [Usuário] ▾ [Sair] │
├─────────────────────────────────────────────────────────┤
│ Adicionar: [_________________________] [Adicionar] │
├─────────────────────────────────────────────────────────┤
│ A COMPRAR │
│ [☐] Selecionar todos │
│ │
│ [ ] Arroz [x]│
│ [ ] Feijão [x]│
│ [ ] Leite [x]│
│ │
│ [Excluir Selecionados] │
├─────────────────────────────────────────────────────────┤
│ COMPRADOS │
│ │
│ [✓] Arroz (riscado) [x]│
│ [✓] Café (riscado) [x]│
│ │
│ [Excluir Comprados] │
└─────────────────────────────────────────────────────────┘

**Comportamento:**
- Interface responsiva e atualização instantânea das listas.
- Itens "Comprados" aparecem com texto riscado.
- Confirmação para ações de exclusão em lote.

## 4. Casos de Uso Detalhados

### UC01: Adicionar Item
**Ator:** Usuário autenticado.
**Fluxo Principal:**
1. Usuário digita o nome do item no campo.
2. Usuário pressiona `Enter` ou clica em "Adicionar".
3. Sistema valida o campo (não vazio, máximo 100 chars, não duplicado).
4. Sistema adiciona o item à lista "A COMPRAR" (checkbox desmarcado).
5. O campo de entrada é limpo.
**Regras de Negócio:**
- RN01: Item não pode ser vazio ou conter apenas espaços.
- RN02: Máximo de 100 caracteres por item.
- RN03: Não permite itens duplicados *na mesma lista* para o mesmo usuário.

### UC02: Marcar Item como Comprado
**Ator:** Usuário autenticado.
**Fluxo Principal:**
1. Usuário clica no checkbox de um item na lista "A COMPRAR".
2. Sistema marca visualmente o checkbox.
3. O item é movido **instantaneamente** para a lista "COMPRADOS".
4. O texto do item aparece riscado.

### UC03: Desmarcar Item
**Ator:** Usuário autenticado.
**Fluxo Principal:**
1. Usuário clica no checkbox de um item na lista "COMPRADOS".
2. Sistema desmarca visualmente o checkbox.
3. O item é movido **instantaneamente** de volta para "A COMPRAR".
4. O texto do item volta ao normal (sem riscar).

### UC04: Excluir Itens Comprados (Em Lote)
**Ator:** Usuário autenticado.
**Fluxo Principal:**
1. Usuário clica em "Excluir Comprados".
2. Sistema exibe confirmação: *"Excluir todos os itens comprados?"*.
3. Usuário confirma.
4. Sistema remove **todos** os itens da lista "COMPRADOS".

### UC05: Excluir Itens Selecionados da Lista Principal
**Ator:** Usuário autenticado.
**Pré-condição:** Pelo menos um item selecionado em "A COMPRAR".
**Fluxo Principal:**
1. Usuário seleciona itens (checkbox individual ou usando o "Selecionar todos").
2. Usuário clica em "Excluir Selecionados".
3. Sistema exibe confirmação: *"Excluir X item(ns) selecionado(s)?"*.
4. Usuário confirma.
5. Sistema remove **apenas** os itens selecionados de "A COMPRAR".

### UC06: Checkbox Mestre
**Ator:** Usuário autenticado.
**Comportamento:**
- Clicar seleciona/deseleciona **todos** os itens de "A COMPRAR" de uma vez.
- Se **alguns** (mas não todos) itens estão selecionados, o checkbox mestre mostra estado **indeterminado** (-).
- O estado do checkbox mestre é atualizado automaticamente conforme itens são selecionados/deselecionados individualmente.

## 5. Especificações de Design

### 5.1. Esquema de Cores
```css
/* Cores Principais */
--primary-color: #2F3E46;    /* Azul-acinzentado escuro */
--secondary-color: #E9ECEF;  /* Cinza claro quente (fundo) */
--accent-color: #4A7C7A;     /* Verde-azulado suave (destaques) */
--neutral-color: #6C757D;    /* Cinza médio neutro (texto secundário) */

/* Aplicação */
Fundo da página: var(--secondary-color)
Cabeçalhos, botões primários: var(--primary-color)
Botões secundários, elementos ativos: var(--accent-color)
Texto secundário, bordas: var(--neutral-color)
Cartões, listas: white

5.2. Estilos Visuais
Bordas: Arredondadas em todos os elementos interativos (border-radius: 0.5rem).

Layout:

Desktop: Container centralizado (max-width: 600px).

Mobile: Ocupa 100% da largura com padding.

Alinhamento interno dos elementos: à esquerda.

Tipografia:

Títulos: 1.25rem, peso 600, cor #2F3E46.

Texto normal: 1rem, cor #333.

Texto riscado (itens comprados): text-decoration: line-through, cor #6C757D.

6. Modelo de Dados (Conceitual)
6.1. Entidade: Usuário (User)
Propósito: Representa uma conta no sistema.

Atributos:

nome (string, obrigatório)

email (string, obrigatório, único)

senha_criptografada (string, obrigatório)

Relacionamento: Um Usuário tem muitos Itens.

6.2. Entidade: Item (Item)
Propósito: Representa um produto na lista de compras.

Atributos:

nome (string, obrigatório, até 100 caracteres)

comprado (booleano, padrão: false)

user_id (referência ao Usuário, obrigatório)

Regras:

O nome deve ser único por usuário dentro do mesmo estado (comprado ou não).

Pertence a um único Usuário.

7. Entregáveis e Definição de Pronto (DoD)
7.1. MVP (Primeira Entrega)
Sistema de autenticação (login, cadastro, logout).

Adicionar itens à lista "A Comprar".

Marcar/desmarcar itens como comprados (com movimentação entre listas).

Visualizar as duas listas ("A Comprar" e "Comprados") de forma separada.

Excluir todos os itens comprados em lote.

Layout responsivo que segue o esquema de cores e estilos definidos.

7.2. Definição de Pronto (DoD)
Um requisito é considerado PRONTO quando:

✅ Passa em todos os testes automatizados relacionados.

✅ Funciona perfeitamente em resoluções desktop e mobile.

✅ Segue fielmente todas as especificações de design (cores, bordas, layout).

✅ Foi revisado em pair programming (código gerado por IA + humano).

✅ A documentação da funcionalidade (comentários, PR) foi atualizada.

✅ Não possui bugs críticos ou de experiência do usuário conhecidos.

Versão: 1.0.0
Status: Aprovado
Criado em: 16 de janeiro de 2026
Última Revisão: 16 de janeiro de 2026
Alinhado com: TaskFlow Constitution v1.0.0