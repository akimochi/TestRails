require 'rubygems'
require 'google/api_client'
#上記の読み込みは過去バージョンのため、下記を試す
#require 'google/apis'
#require 'google/apis/drive_v2'
require 'trollop'

#google developerで取得したキー
DEVELOPER_KEY = 'AIzaSyAeoGY4AcZO0-rz0eEu4gRc6-lqMN9GS58'
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'

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