class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: %i[edit update destroy]

  skip_before_action :set_item, only: [:delete_all_purchased]

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
    if params[:item].present?
      success = @item.update(item_params)
    elsif params[:completed].present?
      success = @item.update(completed: params[:completed] == '1')
    else
      success = false
    end
    if success
      redirect_to items_path, notice: 'Item atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: 'Item removido com sucesso.'
  end


  def delete_all_purchased
    current_user.items.where(completed: true).destroy_all
    redirect_to items_path, notice: 'Todos os itens comprados foram excluídos com sucesso.'
  end

  private

  def set_item
    @item = current_user.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :quantity, :notes, :completed)
  end
end
