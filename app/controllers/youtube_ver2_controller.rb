require 'rexml/document'
require 'rubygems'
require 'google/api_client'
require 'trollop'

DEVELOPER_KEY = '自分のYoutube　APIキー'
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'

class YoutubeVer2Controller < ApplicationController
  # 初期処理
  def index
    # ラジオボタン初期セット
    @videoTyoe0 = true
    @videoTyoe1 = false
    @videoTyoe2 = false
    respond_to do |format|
      format.html
    end
  end

  # 検索処理
  def search

    keyword = params[:keyword]
    if keyword.empty?
      # 検索語が空の場合は、何もしない
      render :action => 'index'
      return
    end
    
    opts = Trollop::options do
      opt :q, 'Search term', :type => String, :default => keyword
      opt :max_results, 'Max results', :type => :int, :default => 25
    end

    # サービス取得処理
    client, youtube = get_service

    begin
      # データ取得処理
      search_response = client.execute!(
      :api_method => youtube.search.list,
      :parameters => {
        :part => 'snippet',
        :q => opts[:q],
        :maxResults => opts[:max_results]
      }
      )
    
      # ハッシュでデータを格納するために用意
      videoList = Hash::new
      channelList = Hash::new
      playList = Hash::new
        
      search_response.data.items.each do |search_result|
        case search_result.id.kind
        when 'youtube#video'
          #通常の動画
          videoList.store("#{search_result.snippet.title}", "https://www.youtube.com/watch?v=#{search_result.id.videoId}")
        when 'youtube#channel'
          #チャンネル
          channelList.store("#{search_result.snippet.title}", "https://www.youtube.com/channel/#{search_result.id.channelId}")
        when 'youtube#playlist'
          #再生リスト
          playList.store("#{search_result.snippet.title}", "https://www.youtube.com/playlist?list=#{search_result.id.playlistId}")
        end
      end

      #結果をコンソールに出力
      #puts "Channels:\n", channelList, "\n"
      #puts "Playlists:\n", playList, "\n"
      
      video = params[:video]
      puts 'params', video['type']
       # 検索条件と検索結果のセット
        case video['type']
        when '0'
          @data = videoList
          @videoTyoe0 = true
          @videoTyoe1 = false
          @videoTyoe2 = false
        when '1'
          @data = channelList
          @videoTyoe0 = false
          @videoTyoe1 = true
          @videoTyoe2 = false
        when '2'
          @data = playList
          @videoTyoe0 = false
          @videoTyoe1 = false
          @videoTyoe2 = true
        end
       @keyword = keyword
       #@video = video
    rescue Google::APIClient::TransmissionError => e
      #例外処理
      puts e.result.body
    end

    render :action => 'index'
  end

  # サービス取得処理
  def get_service
    client = Google::APIClient.new(
    :key => DEVELOPER_KEY,
    :authorization => nil,
    :application_name => $PROGRAM_NAME,
    :application_version => '1.0.0'
    )
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

    return client, youtube
  end
  
end
