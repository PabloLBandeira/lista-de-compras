# Blueprint de Adição de Itens à Lista

## Objetivo
Implementar a funcionalidade que permite aos usuários logados adicionar itens à sua lista de compras. A funcionalidade deve incluir validações, persistência no banco de dados e uma interface intuitiva.

## Estrutura de Arquivos

### 1. Models
Criar o arquivo `item.rb` em `app/models/`:
```ruby
class Item < ApplicationRecord
  # Associações
  belongs_to :user

  # Validações
  validates :name, presence: true, length: { maximum: 100 }
  validates :quantity, numericality: { greater_than: 0 }, allow_nil: true
end
```

### 2. Controllers
Criar o arquivo `items_controller.rb` em `app/controllers/`:
```ruby
class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: %i[edit update destroy]

  def index
    @items = current_user.items
  end

  def new
    @item = Item.new
  end

  def create
    @item = current_user.items.build(item_params)
    if @item.save
      redirect_to items_path, notice: 'Item adicionado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      redirect_to items_path, notice: 'Item atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: 'Item removido com sucesso.'
  end

  private

  def set_item
    @item = current_user.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :quantity, :notes)
  end
end
```

### 3. Views
Criar os seguintes arquivos em `app/views/items/`:

- **`index.html.erb`**:
  ```erb
  <h1>Minha Lista de Compras</h1>
  <%= link_to 'Adicionar Item', new_item_path %>
  <ul>
    <% @items.each do |item| %>
      <li>
        <%= item.name %> - <%= item.quantity || 'N/A' %>
        <%= link_to 'Editar', edit_item_path(item) %>
        <%= link_to 'Excluir', item_path(item), method: :delete, data: { confirm: 'Tem certeza?' } %>
      </li>
    <% end %>
  </ul>
  ```

- **`new.html.erb` e `edit.html.erb`**:
  ```erb
  <h1><%= @item.new_record? ? 'Adicionar Item' : 'Editar Item' %></h1>
  <%= form_with model: @item do |form| %>
    <div>
      <%= form.label :name, 'Nome do Item' %>
      <%= form.text_field :name, required: true %>
    </div>
    <div>
      <%= form.label :quantity, 'Quantidade' %>
      <%= form.number_field :quantity %>
    </div>
    <div>
      <%= form.label :notes, 'Notas' %>
      <%= form.text_area :notes %>
    </div>
    <div>
      <%= form.submit %>
    </div>
  <% end %>
  ```

### 4. Rotas
Adicionar as rotas em `config/routes.rb`:
```ruby
resources :items
```

### 5. Banco de Dados
Criar a migration para a tabela `items`:
```bash
rails generate migration CreateItems name:string quantity:integer notes:text user:references
```

Executar a migration:
```bash
rails db:migrate
```

### 6. Testes
Criar testes para o model e controller em `spec/models/item_spec.rb` e `spec/controllers/items_controller_spec.rb`:

- **Model Test**:
  ```ruby
  require 'rails_helper'

  RSpec.describe Item, type: :model do
    it { should validate_presence_of(:name) }
    it { should belong_to(:user) }
  end
  ```

- **Controller Test**:
  ```ruby
  require 'rails_helper'

  RSpec.describe ItemsController, type: :controller do
    let(:user) { User.create(name: 'Test User', email: 'test@example.com', password: 'password') }
    let(:item) { user.items.create(name: 'Test Item') }

    before { sign_in user }

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      it 'creates a new item' do
        expect {
          post :create, params: { item: { name: 'New Item' } }
        }.to change(Item, :count).by(1)
      end
    end
  end
  ```

### 7. JavaScript
Criar o arquivo `item_interactions.js` em `app/javascript/controllers/`:
```javascript
document.addEventListener('DOMContentLoaded', () => {
  const items = document.querySelectorAll('.item');

  items.forEach((item) => {
    item.addEventListener('click', () => {
      alert(`Você clicou no item: ${item.textContent}`);
    });
  });
});
```

### 8. Dockerização
Certificar-se de que o ambiente Docker suporta a funcionalidade:
- Atualizar o `Dockerfile` e `docker-compose.yml` conforme necessário.

### 9. Verificações Finais
- Testar a funcionalidade acessando as rotas no navegador.
- Garantir que todos os testes estão passando:
  ```bash
  rspec
  ```