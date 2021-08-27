class AddIsSuggested < ActiveRecord::Migration[6.1]
  def change
    add_column :ads, :is_suggested, :boolean, default: false
  end
end
