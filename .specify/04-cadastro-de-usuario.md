# Blueprint de Cadastro de Usuário

## Objetivo
Implementar o CRUD completo para a funcionalidade de cadastro de usuários, seguindo os padrões de arquitetura MVC e as diretrizes estabelecidas nos arquivos de especificação.

## Estrutura de Arquivos

### 1. Models
Criar o arquivo `user.rb` em `app/models/`:
```ruby
class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Validações
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Escopos
  scope :active, -> { where(active: true) }
end
```

### 2. Controllers
Criar o arquivo `users_controller.rb` em `app/controllers/`:
```ruby
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.all
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: 'Usuário criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Usuário atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'Usuário excluído com sucesso.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
```

### 3. Views
Criar os seguintes arquivos em `app/views/users/`:

- **`index.html.erb`**:
  ```erb
  <h1>Lista de Usuários</h1>
  <%= link_to 'Novo Usuário', new_user_path %>
  <ul>
    <% @users.each do |user| %>
      <li>
        <%= link_to user.name, user_path(user) %>
        <%= link_to 'Editar', edit_user_path(user) %>
        <%= link_to 'Excluir', user_path(user), method: :delete, data: { confirm: 'Tem certeza?' } %>
      </li>
    <% end %>
  </ul>
  ```

- **`new.html.erb` e `edit.html.erb`**:
  ```erb
  <h1><%= @user.new_record? ? 'Novo Usuário' : 'Editar Usuário' %></h1>
  <%= form_with model: @user do |form| %>
    <div>
      <%= form.label :name %>
      <%= form.text_field :name %>
    </div>
    <div>
      <%= form.label :email %>
      <%= form.email_field :email %>
    </div>
    <div>
      <%= form.label :password %>
      <%= form.password_field :password %>
    </div>
    <div>
      <%= form.label :password_confirmation %>
      <%= form.password_field :password_confirmation %>
    </div>
    <div>
      <%= form.submit %>
    </div>
  <% end %>
  ```

- **`show.html.erb`**:
  ```erb
  <h1><%= @user.name %></h1>
  <p>Email: <%= @user.email %></p>
  <%= link_to 'Editar', edit_user_path(@user) %>
  <%= link_to 'Voltar', users_path %>
  ```

### 4. Rotas
Adicionar as rotas em `config/routes.rb`:
```ruby
resources :users
```

### 5. Banco de Dados
Criar a migration para a tabela `users` (incluindo a coluna remember_created_at:datetime para compatibilidade com o módulo :rememberable do Devise):
```bash
rails generate migration CreateUsers name:string email:string:uniq encrypted_password:string remember_created_at:datetime active:boolean
```

Executar a migration:
```bash
rails db:migrate
```

### 6. Testes
Criar testes para o model e controller em `spec/models/user_spec.rb` e `spec/controllers/users_controller_spec.rb`:

- **Model Test**:
  ```ruby
  require 'rails_helper'

  RSpec.describe User, type: :model do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should have_secure_password }
  end
  ```

- **Controller Test**:
  ```ruby
  require 'rails_helper'

  RSpec.describe UsersController, type: :controller do
    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end
  end
  ```

### 7. Segurança e Autenticação
Integrar com Devise para autenticação:
```bash
rails generate devise:install
rails generate devise User
rails db:migrate
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