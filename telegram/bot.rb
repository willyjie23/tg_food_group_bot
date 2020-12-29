require File.expand_path('../config/environment', __dir__)

require 'telegram/bot'

token = '1496794903:AAGDNI0a32YGsnyhNrrh2mrkaB_wLP-M_rw'
# photo_url = "https://img.komicolle.org/2020-04/15876811129839.jpg"
# c_url = 'https://img.achingfoodie.tw/uploads/20200610202937_33.png'
Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    if !User.exists?(telegram_id: message.from.id)
      user = User.create(name: message.from.first_name, telegram_id: message.from.id)
    else
      user = User.find_by(telegram_id: message.from.id)
    end

    if !Store.exists?(name: message.text)
      bot.api.send_message(chat_id: message.chat.id, text: "輸入 /add, 名稱, 網址")
      store = nil
    else
      store = Store.find_by(name: message.text)
    end

    case message.text
    when store&.name
      bot.api.send_message(chat_id: message.chat.id, text: "#{store.name}： #{store.url}")
      bot.api.send_photo(chat_id: message.chat.id, photo: photo_url)
    when '訂餐'
      bot.api.send_message(chat_id: message.chat.id, text: "#{user.name} 要吃啥")
    when '/add'
      bot.api.send_message(chat_id: message.chat.id, text: "#{user.name} 你真是好人")
      binding.pry
      result = message.text.split(',')
      Store.create(name: result[1].strip, url: result[2].strip)
    else
      bot.api.send_message(chat_id: message.chat.id, text: '可以打我看得懂的嗎？')
    end
  end
end
