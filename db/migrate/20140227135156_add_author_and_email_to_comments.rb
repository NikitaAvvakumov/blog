class AddAuthorAndEmailToComments < ActiveRecord::Migration
  def change
    add_column :comments, :author, :string
    add_column :comments, :email, :string
  end
end
