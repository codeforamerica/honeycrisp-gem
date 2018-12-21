Cfa::Styleguide::Engine.routes.draw do
  get '/styleguide' => 'pages#index', as: :styleguide_main
  get '/styleguide/cbo-dashboard' => 'pages#cbo_dashboard', as: :styleguide_cbo_dashboard
  get '/styleguide/cbo-analytics' => 'pages#cbo_analytics', as: :styleguide_cbo_analytics
  get '/styleguide/current' => 'pages#current', as: :styleguide_current
  get '/styleguide/custom-docs' => 'pages#custom_docs', as: :styleguide_custom_docs
  get '/styleguide/form-builder' => 'pages#form_builder', as: :styleguide_form_builder
  get '/styleguide/examples/*example_path' => 'examples#show', as: :styleguide_example
end