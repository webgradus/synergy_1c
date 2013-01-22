class Add1cFields < ActiveRecord::Migration
  def self.up
      add_column :products, :code_1c, :string
      add_column :variants, :code_1c, :string
  end
  def self.down
      remove_column :products, :code_1c
      remove_column :variants, code_1c
  end
end
