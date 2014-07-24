Siye::Engine.routes.draw do
  get '/' => 'index#index'
end

Siye::Engine.routes.draw do
  resource :devtest do
    collection do
      get :video
      get :aliyun
    end
  end
end