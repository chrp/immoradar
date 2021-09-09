class AddNotifiedAt < ActiveRecord::Migration[6.1]
  def change
    add_column :ads, :notified_at, :datetime, default: nil
  end
end
