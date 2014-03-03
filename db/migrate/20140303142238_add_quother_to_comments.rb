class AddQuotherToComments < ActiveRecord::Migration
  def change
    add_column :comments, :quother, :boolean, default: false
  end
end
