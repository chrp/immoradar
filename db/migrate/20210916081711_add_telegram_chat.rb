class AddTelegramChat < ActiveRecord::Migration[6.1]
  def change
    create_table :telegram_chats do |t|
      t.string :chat_id, null: false
      t.timestamps
    end
  end
end
