Rails.application.routes.draw do

  root 'welcome#index'
  
  get 'test' => 'welcome#test'

  get 'index' => 'welcome#index'

  post 'index' => 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
