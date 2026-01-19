class AddResetPasswordToUsers < ActiveRecord::Migration[8.1]
  def change
    # Só adiciona se não existir
    unless column_exists?(:users, :reset_password_token)
      add_column :users, :reset_password_token, :string
    end
    unless column_exists?(:users, :reset_password_sent_at)
      add_column :users, :reset_password_sent_at, :datetime
    end
    unless index_exists?(:users, :reset_password_token)
      add_index :users, :reset_password_token, unique: true
    end
  end
end
