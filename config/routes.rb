Cfa::Styleguide::Engine.routes.draw do
  get '/styleguide' => 'pages#index'
  get '/styleguide/cbo-dashboard' => 'pages#cbo_dashboard'
  get '/styleguide/cbo-analytics' => 'pages#cbo_analytics'
  get '/styleguide/current' => 'pages#current'
  get '/styleguide/custom-docs' => 'pages#custom_docs'
end