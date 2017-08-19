Rails.application.routes.draw do
  resources :youtube_ver2 do
    #ルーティングの追加
    collection do
      get 'search'
      #post 'reset'
    end
  end
end
