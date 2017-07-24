require 'rexml/document'
require 'youtube_test.rb'

DEVELOPER_KEY = 'AIzaSyAeoGY4AcZO0-rz0eEu4gRc6-lqMN9GS58'
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'

class YoutubeVer2Controller < ApplicationController
  def index
    respond_to do |format|
      format.html
    end
  end

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

  # searchアクション
  def search

    # 検索語をクエリにセットして、リクエストする
    keyword = params[:keyword]
    opts = Trollop::options do
      opt :q, 'Search term', :type => String, :default => keyword
      opt :max_results, 'Max results', :type => :int, :default => 25
    end

    client, youtube = get_service

    begin
      # Call the search.list method to retrieve results matching the specified
      # query term.
      search_response = client.execute!(
      :api_method => youtube.search.list,
      :parameters => {
        :part => 'snippet',
        :q => opts[:q],
        :maxResults => opts[:max_results]
      }
      )

      videos = []
      channels = []
      playlists = []
      videoURL = []
      
      # Add each result to the appropriate list, and then display the lists of
      # matching videos, channels, and playlists.
      videoList = Hash::new
      
      search_response.data.items.each do |search_result|
        case search_result.id.kind
        when 'youtube#video'
          #videos << "#{search_result.snippet.title}"
          #videoURL << "https://www.youtube.com/watch?v=#{search_result.id.videoId}"
          videoList.store("#{search_result.snippet.title}", "https://www.youtube.com/watch?v=#{search_result.id.videoId}")
        when 'youtube#channel'
          channels << "#{search_result.snippet.title} (#{search_result.id.channelId})"
        when 'youtube#playlist'
          playlists << "#{search_result.snippet.title} (#{search_result.id.playlistId})"
        end
      end

      #結果をコンソールに出力
      puts "Videos:\n", videos, "\n"
      puts "Channels:\n", channels, "\n"
      puts "Playlists:\n", playlists, "\n"
      
      # 検索結果の表示と動画のURLを追加する
       @data = videoList
       @keyword = keyword
    rescue Google::APIClient::TransmissionError => e
      #例外処理
      puts e.result.body
    end

    render :action => 'index'
  end

end
