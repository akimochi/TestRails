Rails.application.routes.draw do
  resources :youtube_ver2 do
    #ルーティングの追加
    #エラーが出る場合は、rake routesで確認
    collection do
      get 'search'
      get 'register'
    end
  end
end
