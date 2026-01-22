2.3. Logout Seguro
✅ O botão de logout deve obrigatoriamente usar button_to (formulário DELETE), nunca depender exclusivamente de link_to com method: :delete, para garantir compatibilidade com ambientes sem JavaScript e o padrão Rails 7+ com importmap.
1. Objetivo
Estabelecer regras e limitações claras para o GitHub Copilot durante o desenvolvimento do TaskFlow, garantindo conformidade com a arquitetura MVC, princípios Rails e padrões de qualidade definidos. A experiência mobile será garantida via PWA responsivo, sem dependência de app nativo.

2. Regras Gerais de Comportamento
2.1. Arquitetura MVC Estrita
❌ NÃO CRIAR:
- Métodos de negócio em controllers
- Lógica de apresentação em models
- Controllers que não seguem REST
- Views com JavaScript embutido

✅ SEMPRE SEGUIR:
- Fat models, thin controllers
- Views com código ERB mínimo
- Controllers apenas para coordenação
- Service objects para lógica complexa

2.2. Rails Convention Over Configuration
❌ NÃO INVENTAR:
- Novos padrões de nomenclatura
- Estruturas de diretórios alternativas
- Configurações fora do padrão Rails

✅ SEMPRE USAR:
- Scaffold para CRUD básico
- Generators Rails para tudo
- Configurações padrão do Rails 8.1.1
- Nomes de métodos em inglês

3. Regras Específicas por Camada
3.1. Models (ActiveRecord)
# ❌ PROIBIDO
class Task < ApplicationRecord
  # Não criar métodos com lógica de apresentação
  def formatted_deadline
    deadline.strftime("%d/%m/%Y") # ❌ Lógica de view no model
  end
  
  # Não criar validações complexas demais
  validate :complex_business_logic # ❌ Usar service object
end

# ✅ PERMITIDO
class Task < ApplicationRecord
  # Escopos simples
  scope :completed, -> { where(completed: true) }
  
  # Validações padrão
  validates :title, presence: { message: "Título não pode ficar em branco" }
  validates :due_date, comparison: { greater_than: Date.today }
  
  # Métodos simples de negócio
  def overdue?
    due_date < Date.today && !completed?
  end
end

3.2. Controllers (ActionController)
# ❌ PROIBIDO
class TasksController < ApplicationController
  def create
    # Não criar lógica complexa no controller
    @task = Task.new(task_params)
    if @task.save
      # Não fazer múltiplas coisas em uma action
      send_email_notification(@task)
      update_related_records(@task)
      # ... mais lógica ...
    end
  end
end

# ✅ PERMITIDO
class TasksController < ApplicationController
  def create
    @task = Task.new(task_params)
    
    if @task.save
      respond_to do |format|
        format.html { redirect_to @task, notice: "Tarefa criada com sucesso." }
        format.turbo_stream # Renderiza app/views/tasks/create.turbo_stream.erb
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  def task_params
    params.require(:task).permit(:title, :description, :due_date, :priority)
  end
end

3.3. Views (ERB + Turbo)
<%# ❌ PROIBIDO %>
<% # Não colocar lógica complexa na view %>
<% if current_user.admin? && @task.overdue? && !@task.assigned_to.nil? %>
  <!-- Não criar HTML complexo condicional -->
<% end %>

<%# ✅ PERMITIDO %>
<%= turbo_frame_tag "task_#{@task.id}" do %>
  <div class="task-card">
    <h3><%= @task.title %></h3>
    <p><%= @task.description %></p>
    
    <%# Usar partials para componentes reutilizáveis %>
    <%= render "tasks/status_badge", task: @task %>
  </div>
<% end %>

4. Regras para Hotwire (Turbo + Stimulus)
4.1. Turbo Streams
<%# ❌ PROIBIDO %>
<turbo-stream action="update" target="task_1">
  <template>
    <!-- Não enviar HTML grande demais -->
    <%= render "complex_partial", locals: { ... } %>
  </template>
</turbo-stream>

<%# ✅ PERMITIDO %>
<%= turbo_stream.update "task_#{@task.id}" do %>
  <%= render "tasks/task", task: @task %>
<% end %>

4.2. Stimulus Controllers
// ❌ PROIBIDO
// Não criar controllers com múltiplas responsabilidades
import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  connect() {
    // Não fazer tudo no connect
    this.setupValidation()
    this.bindEvents()
    this.initializeThirdPartyLibrary()
  }
}

// ✅ PERMITIDO
// Controllers pequenos e focados
import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["input", "counter"]
  
  updateCounter() {
    const count = this.inputTarget.value.length
    this.counterTarget.textContent = `${count}/100`
  }
}

5. Regras de Segurança
5.1. SQL Injection
# ❌ NUNCA FAZER
Task.where("title LIKE '%#{params[:search]}%'") # SQL Injection!

# ✅ SEMPRE USAR
Task.where("title LIKE ?", "%#{params[:search]}%")
# ou melhor ainda
Task.where("title ILIKE ?", "%#{sanitize_sql_like(params[:search])}%")

5.2. Strong Parameters
# ❌ NUNCA PERMITIR
params.permit! # Permite tudo - MUITO PERIGOSO

# ✅ SEMPRE FILTRAR
params.require(:task).permit(:title, :description, :due_date)

5.3. Autenticação e Autorização
5.3. Autenticação e Autorização

6. Regras de Testes
6.1. Test Pyramid Enforcement
# ❌ NÃO CRIAR
# Muitos testes de sistema para coisas simples
feature "User views task" do
  # Teste E2E para funcionalidade simples
end

# ✅ SEGUIR PIRÂMIDE
# 1. Teste de Modelo (Unitário)
RSpec.describe Task, type: :model do
  it { should validate_presence_of(:title) }
end

# 2. Teste de Controller (Integração)
RSpec.describe TasksController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end

# 3. Teste de Sistema (E2E - somente fluxos críticos)
RSpec.describe "Task management", type: :system do
  it "allows user to create a task" do
    # Fluxo completo do usuário
  end
end

7. Regras para Docker e DevOps
7.1. Dockerfile
# ❌ NÃO USAR
FROM ruby:latest # Tag não específica

# ✅ SEMPRE USAR
FROM ruby:3.4.8-slim-bookworm # Versão específica

7.2. Variáveis de Ambiente
# ❌ NÃO CODAR VALORES FIXOS
database_password = "senha123" # No código!

# ✅ SEMPRE USAR ENV VARS
database_password = ENV['DATABASE_PASSWORD']

8. Regras de Documentação
8.1. Comentários de Código
# ❌ COMENTÁRIOS RUINS
# Incrementa contador
counter += 1 # Óbvio demais

# ✅ COMENTÁRIOS ÚTEIS
# Aplica desconto de 10% para clientes VIP
# Fórmula: valor * 0.9 (regra de negócio específica)
def apply_vip_discount(amount)
  amount * 0.9
end

8.2. Commits
# ❌ MENSAGENS RUINS
git commit -m "fix" # Muito vago

# ✅ MENSAGENS BOAS
git commit -m "fix: corrige validação de data na criação de tarefas

- Validação não permitia datas no passado
- Agora aceita datas até 30 dias atrás
- Adiciona teste para cenário de data inválida"

9. Regras para Mobile (Fase 2 - Angular)
9.1. Componentes Angular
// ❌ PROIBIDO
@Component({
  selector: 'app-task-list',
  templateUrl: './task-list.component.html',
  styleUrls: ['./task-list.component.css']
})
export class TaskListComponent {
  // Não colocar lógica de negócio no componente
  calculateTaskPriority(task: any): string {
    // Lógica que deveria estar no backend
  }
}

// ✅ PERMITIDO
@Component({
  selector: 'app-task-list',
  templateUrl: './task-list.component.html',
  styleUrls: ['./task-list.component.css'],
  standalone: true // Usar standalone components
})
export class TaskListComponent {
  @Input() tasks: Task[] = [];
  
  // Apenas lógica de apresentação
  getPriorityClass(task: Task): string {
    return `priority-${task.priority}`;
  }
}

10. Validação Automática
10.1. Antes de Cada PR
O Copilot deve verificar se o código gerado:

Passa no RuboCop (padrão Rails)

Passa no Brakeman (segurança)

Tem cobertura de testes adequada

Seguiu as convenções de nomenclatura

Não introduziu vulnerabilidades conhecidas

10.2. Checklist de Qualidade
Métodos têm no máximo 10 linhas

Classes têm no máximo 100 linhas

Não há código duplicado

Todas as rotas têm testes

Todos os models têm validações

Todas as views são responsivas

11. Comportamentos Proibidos
11.1. Copilot NUNCA deve:
Criar funcionalidades sem spec aprovada

Ignorar princípios de segurança

Escrever código sem testes

Violar convenções Rails

Criar dependências desnecessárias

Escrever código difícil de testar

Ignorar a pirâmide de testes

Criar God objects/classes

Escrever comentários em inglês

Ignorar padrões de acessibilidade

11.2. Copilot SEMPRE deve:
Seguir TDD (testes primeiro)

Usar service objects para lógica complexa

Aplicar strong parameters

Escapar dados de usuário

Validar inputs no model e controller

Usar I18n para mensagens

Seguir atomic design nos partials

Manter controllers RESTful

Documentar decisões complexas

Revisar código com "pair programming" humano

12. Exceções e Escalações
12.1. Quando quebrar as regras
Algumas situações permitem exceções, mas exigem justificativa:

Performance crítica comprovada

Integração com sistema legado

Requisito específico de negócio

Limitação técnica documentada

12.2. Processo de escalação
Se o Copilot sugerir código que viola estas regras:

Rejeitar a sugestão imediatamente

Documentar a violação no comentário

Solicitar revisão humana

Criar issue no GitHub se necessário

Versão: 1.0.0
Status: Aprovado
Criado em: 16 de janeiro de 2026
Última Revisão: 16 de janeiro de 2026
Alinhado com: TaskFlow Constitution v1.0.0