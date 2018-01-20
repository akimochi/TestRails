require "rss"

#現在のニュースを閲覧、お気に入り登録できるクラス
class NewsWatchController < ApplicationController
  # 初期処理
  def index
    #yahoo
    url = "https://news.yahoo.co.jp/pickup/rss.xml"
    rss = RSS::Parser.parse(url)
    #x.pubDate.today.strftime("%Y年 %m月 %d日") 
    @yahooData = rss.channel.items
    #p @yahooData
    
    #GIGAZINE
    url = "http://feed.rssad.jp/rss/gigazine/rss_2.0"
    rss = RSS::Parser.parse(url)
    @gigazineData = rss.channel.items
    
    #ロケットニュース24
    url = "http://feeds.rocketnews24.com/rocketnews24"
    rss = RSS::Parser.parse(url)
    @rocketData = rss.channel.items
    
    #天気
    uri = URI.parse('http://weather.livedoor.com/forecast/webservice/json/v1?city=140020')
    json = Net::HTTP.get(uri)
    @weatherData = JSON.parse(json)
    p @weatherData["pinpointLocations"]
  end  
end
