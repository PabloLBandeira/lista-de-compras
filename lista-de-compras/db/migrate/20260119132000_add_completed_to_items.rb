class AddCompletedToItems < ActiveRecord::Migration[8.1]
  def change
    add_column :items, :completed, :boolean, default: false
  end
end
