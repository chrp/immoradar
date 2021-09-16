class TelegramChat < ActiveRecord::Base
  validates :chat_id, presence: true
end
