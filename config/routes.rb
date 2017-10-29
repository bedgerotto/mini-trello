Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :people

  root 'home#index'

  # project routes
  get 'project/:id/histories' => 'project#histories'
  post 'project/store' => 'project#store'
  put  'project/:id/update' => 'project#update'
  get   'project/get'   => 'project#get'
  delete  'project/:id/destroy'   => 'project#destroy'

  # history routes
  post 'history/store' => 'history#store'
  put 'history/:id/update' => 'history#update'
  put 'history/:id/status' => 'history#status'
  put 'history/:id/finish' => 'history#finish'
  delete 'history/:id/destroy' => 'history#destroy'

  # task routes
  put 'task/:id/done' => 'task#done'
end
