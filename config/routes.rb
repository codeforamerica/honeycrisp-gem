Cfa::Styleguide::Engine.routes.draw do
  get '/styleguide' => 'pages#index', as: :styleguide_main
  get '/styleguide/form-builder' => 'pages#form_builder', as: :styleguide_form_builder
  get '/styleguide/examples/*example_path' => 'examples#show', as: :styleguide_example
end