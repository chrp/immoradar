require 'pry'
require 'telegram/bot'
require 'sinatra/activerecord'
require './models/telegram_chat'

unless ENV['TELEGRAM_API_KEY']
  require 'dotenv/load'
  Dotenv.load
end

token = ENV['TELEGRAM_API_KEY']

# This part of the bot just handles subscriptions

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      puts "Added #{message.chat.id}"
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
      TelegramChat.find_or_create_by(chat_id: message.chat.id)
    when '/stop'
      puts "Removed #{message.chat.id}"
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
      TelegramChat.find_by(chat_id: message.chat.id)&.destroy
    else
      puts "Unknown message in #{message.chat.id}: #{message.text}"
    end
  end
end
