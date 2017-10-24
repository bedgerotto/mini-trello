Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :people

  root 'home#index'

  get 'project/:id/histories' => 'project#histories'
end
