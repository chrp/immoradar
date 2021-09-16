require 'telegram/bot'

unless ENV['TELEGRAM_API_KEY']
  require 'dotenv/load'
  Dotenv.load
end

class NotifyWithTelegramService
  def initialize
    raise 'Missing Telegram API token' unless ENV['TELEGRAM_API_KEY']
  end

  def call
    return unless ads.any?

    message = ads.map { |e| compose_message(e) }.join("\n\n")

    Telegram::Bot::Client.run(ENV['TELEGRAM_API_KEY']) do |bot|
      TelegramChat.all.map(&:chat_id).each do |chat_id|
        bot.api.send_message(chat_id: chat_id, text: message)
      end
    end

    ads.update_all(notified_at: Time.now)
  end

  private

  def ads
    Ad.where(notified_at: nil)
      .where(is_suggested: true)
      .where.not(is_ignored: 1)
      .order('id ASC')
      .limit(20)
  end

  def compose_message ad
    generic_sub_categories = ['Unbekannt',
                              'Andere Wohnungstypen',
                              'Andere Haustypen',
                              'Weitere Grundstücke & Gärten']

    category = generic_sub_categories.include?(ad.sub_category) ? ad.category : ad.sub_category

    "#{category} in #{ad.postcode}, #{ad.price} EUR\n#{ad.url}"
  end

  def chats
    @chats ||= Chats.instance
  end
end
