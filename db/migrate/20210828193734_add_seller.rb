class AddSeller < ActiveRecord::Migration[6.1]
  def change
    add_column :ads, :seller_name, :string
    add_column :ads, :seller_is_commercial, :boolean
  end
end
