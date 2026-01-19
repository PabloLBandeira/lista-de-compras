# Blueprint de Exclusão de Itens da Lista

## Objetivo
Implementar a funcionalidade que permite aos usuários logados excluir itens que já foram marcados como comprados de suas listas de compras. A funcionalidade deve incluir validações, persistência no banco de dados e uma interface intuitiva.

## Estrutura de Arquivos

### 1. Controllers
Atualizar o arquivo `items_controller.rb` em `app/controllers/` para incluir a ação de exclusão de itens comprados:
```ruby
class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: %i[edit update destroy]

  # ...existing code...

  def destroy_purchased
    purchased_items = current_user.items.where(purchased: true)
    if purchased_items.destroy_all
      redirect_to items_path, notice: 'Itens comprados excluídos com sucesso.'
    else
      redirect_to items_path, alert: 'Erro ao excluir itens comprados.'
    end
  end

  private

  # ...existing code...
end
```

### 2. Views
Atualizar o arquivo `index.html.erb` em `app/views/items/` para incluir a opção de exclusão de itens comprados:
```erb
<h1>Minha Lista de Compras</h1>
<%= link_to 'Adicionar Item', new_item_path %>
<%= link_to 'Excluir Itens Comprados', destroy_purchased_items_path, method: :delete, data: { confirm: 'Tem certeza que deseja excluir todos os itens comprados?' } %>
<ul>
  <% @items.each do |item| %>
    <li>
      <%= item.name %> - <%= item.quantity || 'N/A' %>
      <% if item.purchased %>
        <span>(Comprado)</span>
      <% end %>
      <%= link_to 'Editar', edit_item_path(item) %>
      <%= link_to 'Excluir', item_path(item), method: :delete, data: { confirm: 'Tem certeza?' } %>
    </li>
  <% end %>
</ul>
```

### 3. Rotas
Adicionar a rota para exclusão de itens comprados em `config/routes.rb`:
```ruby
resources :items do
  delete :destroy_purchased, on: :collection
end
```

### 4. Banco de Dados
Certificar-se de que a tabela `items` contém o campo `purchased`:
- `purchased` (boolean, default: false)

Caso contrário, criar uma migration para adicionar o campo:
```bash
rails generate migration AddPurchasedToItems purchased:boolean:default
rails db:migrate
```

### 5. Testes
Criar testes para a nova funcionalidade em `spec/controllers/items_controller_spec.rb`:

- **Controller Test**:
  ```ruby
  require 'rails_helper'

  RSpec.describe ItemsController, type: :controller do
    let(:user) { User.create(name: 'Test User', email: 'test@example.com', password: 'password') }
    let!(:purchased_item) { user.items.create(name: 'Purchased Item', purchased: true) }
    let!(:unpurchased_item) { user.items.create(name: 'Unpurchased Item', purchased: false) }

    before { sign_in user }

    describe 'DELETE #destroy_purchased' do
      it 'deletes only purchased items' do
        expect {
          delete :destroy_purchased
        }.to change { user.items.where(purchased: true).count }.from(1).to(0)
        expect(user.items.where(purchased: false).count).to eq(1)
      end

      it 'redirects to the items index' do
        delete :destroy_purchased
        expect(response).to redirect_to(items_path)
      end
    end
  end
  ```

### 6. JavaScript
Atualizar o arquivo `item_interactions.js` em `app/javascript/controllers/` para incluir interatividade na exclusão de itens comprados:
```javascript
document.addEventListener('DOMContentLoaded', () => {
  const deletePurchasedButton = document.querySelector('#delete-purchased-items');

  if (deletePurchasedButton) {
    deletePurchasedButton.addEventListener('click', (event) => {
      if (!confirm('Tem certeza que deseja excluir todos os itens comprados?')) {
        event.preventDefault();
      }
    });
  }
});
```

### 7. Dockerização
Certificar-se de que o ambiente Docker suporta a funcionalidade:
- Atualizar o `Dockerfile` e `docker-compose.yml` conforme necessário.

### 8. Verificações Finais
- Testar a funcionalidade acessando as rotas no navegador.
- Garantir que todos os testes estão passando:
  ```bash
  rspec
  ```