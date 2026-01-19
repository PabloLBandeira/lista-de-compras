# Blueprint de Login de Usuário

## Objetivo
Implementar a funcionalidade de login para usuários cadastrados, garantindo autenticação segura e persistência de sessão.

## Estrutura de Arquivos

### 1. Controllers
Criar o arquivo `sessions_controller.rb` em `app/controllers/`:
```ruby
class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Login realizado com sucesso.'
    else
      flash.now[:alert] = 'Email ou senha inválidos.'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'Logout realizado com sucesso.'
  end
end
```

### 2. Views
Criar os seguintes arquivos em `app/views/sessions/`:

- **`new.html.erb`**:
  ```erb
  <h1>Login</h1>
  <%= form_with url: login_path, method: :post do |form| %>
    <div>
      <%= form.label :email %>
      <%= form.email_field :email, required: true %>
    </div>
    <div>
      <%= form.label :password %>
      <%= form.password_field :password, required: true %>
    </div>
    <div>
      <%= form.submit 'Entrar' %>
    </div>
  <% end %>
  <%= link_to 'Cadastre-se', new_user_path %>
  ```

### 3. JavaScript
Criar o arquivo `login_validation.js` em `app/javascript/controllers/`:
```javascript
document.addEventListener('DOMContentLoaded', () => {
  const form = document.querySelector('form');

  form.addEventListener('submit', (event) => {
    const email = form.querySelector('[name="email"]');
    const password = form.querySelector('[name="password"]');

    if (!email.value || !password.value) {
      event.preventDefault();
      alert('Por favor, preencha todos os campos.');
    }
  });
});
```

### 4. Rotas
Adicionar as rotas em `config/routes.rb`:
```ruby
get '/login', to: 'sessions#new'
post '/login', to: 'sessions#create'
delete '/logout', to: 'sessions#destroy'
```

### 5. Banco de Dados
Certificar-se de que a tabela `users` contém os campos necessários para o Devise (incluindo :rememberable):
- `email` (string, único)
- `encrypted_password` (string)
- `remember_created_at` (datetime)

Caso contrário, criar uma migration para adicionar os campos:
```bash
rails generate migration AddAuthenticationToUsers email:string:uniq encrypted_password:string remember_created_at:datetime
rails db:migrate
```

### 6. Testes
Criar testes para o controller em `spec/controllers/sessions_controller_spec.rb`:

- **Controller Test**:
  ```ruby
  require 'rails_helper'

  RSpec.describe SessionsController, type: :controller do
    describe 'POST #create' do
      let!(:user) { User.create(name: 'Test User', email: 'test@example.com', password: 'password') }

      it 'logs in with valid credentials' do
        post :create, params: { email: user.email, password: 'password' }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
      end

      it 'does not log in with invalid credentials' do
        post :create, params: { email: user.email, password: 'wrongpassword' }
        expect(session[:user_id]).to be_nil
        expect(response).to render_template(:new)
      end
    end

    describe 'DELETE #destroy' do
      it 'logs out the user' do
        delete :destroy
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(login_path)
      end
    end
  end
  ```

### 7. Segurança
Integrar com Devise para reforçar a segurança:
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