Rails.application.routes.draw do
  resources :youtube_ver2 do
    #ルーティングの追加
    collection do
      get 'search'
      #post 'reset'
    end
  end
  resources :youtube_ver3
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
