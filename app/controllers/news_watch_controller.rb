require "rss"

#現在のニュースを閲覧、お気に入り登録できるクラス
class NewsWatchController < ApplicationController
  # 初期処理
  def index
    #GIGAZINE
    #url = "http://feed.rssad.jp/rss/gigazine/rss_2.0"
    #yahoo
    #url = "https://news.yahoo.co.jp/pickup/rss.xml"
    #ロケットニュース24
    url = "http://feeds.rocketnews24.com/rocketnews24"
    rss = RSS::Parser.parse(url)
    rss.channel.items.each do|x|
      puts x.title
    end
  end  
end
