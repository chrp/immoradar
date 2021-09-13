class Chats
  include Singleton

  FILENAME = File.join(File.expand_path(File.dirname(__FILE__)), 'chats.txt')

  def initialize
    read
  end

  def add chat_id
    unless @chat_ids.include?(chat_id)
      @chat_ids << chat_id
      write
    end
  end

  def remove chat_id
    if @chat_ids.include?(chat_id)
      @chat_ids.delete(chat_id)
      write
    end
  end

  def all
    @chat_ids
  end

  private

  def read
    txt = File.read(FILENAME) rescue ''
    @chat_ids = txt.split(';')
  end

  def write
    File.write(FILENAME, @chat_ids.join(';'))
  end
end
