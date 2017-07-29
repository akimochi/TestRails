require 'google/apis/youtube_v3'
require 'active_support/all'

GOOGLE_API_KEY="YOUR_API_KEY"

class YoutubeVer3Controller < ApplicationController
  
  def index
    find_videos('レノファ')
  end
  
  def find_videos(keyword)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = GOOGLE_API_KEY
  
    next_page_token = nil
    begin
      opt = {
        q: keyword,
        type: 'video',
        max_results: 50,
        order: :date,
        page_token: next_page_token,
        published_after: 1.months.ago.iso8601,
        published_before: Time.now.iso8601
      }
      results = service.list_searches(:snippet, opt)
      results.items.each do |item|
        snippet = item.snippet
        puts "\"#{snippet.title}\" by #{snippet.channel_title} (#{snippet.published_at})"
      end
  
      next_page_token = results.next_page_token
    end while next_page_token.present?
  end

end
