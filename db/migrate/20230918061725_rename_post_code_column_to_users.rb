class RenamePostCodeColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :post_code, :postal_code
  end
end
