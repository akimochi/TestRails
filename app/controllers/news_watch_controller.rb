require "rss"

#現在のニュースを閲覧、お気に入り登録できるクラス
class NewsWatchController < ApplicationController
  # 初期処理
  def index
    #yahoo
    url = "https://news.yahoo.co.jp/pickup/rss.xml"
    rss = RSS::Parser.parse(url)
    @yahooData = rss.channel.items
    
    #GIGAZINE
    url = "http://feed.rssad.jp/rss/gigazine/rss_2.0"
    rss = RSS::Parser.parse(url)
    @gigazineData = rss.channel.items
    
    #ロケットニュース24
    url = "http://feeds.rocketnews24.com/rocketnews24"
    rss = RSS::Parser.parse(url)
    @rocketData = rss.channel.items
  end  
end
