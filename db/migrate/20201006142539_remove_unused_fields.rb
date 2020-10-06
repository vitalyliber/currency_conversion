class RemoveUnusedFields < ActiveRecord::Migration[6.0]
  def change
    remove_column :rates, :from
    remove_column :rates, :to
  end
end
