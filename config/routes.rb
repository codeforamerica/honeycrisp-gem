Cfa::Styleguide::Engine.routes.draw do
  get "/styleguide" => "pages#index", as: :styleguide_main
  get "/styleguide/form-builder" => "pages#form_builder", as: :styleguide_form_builder
  get "/styleguide/examples/*example_path" => "examples#show", as: :styleguide_example
  get "/styleguide/emojis" => "pages#emojis", as: :styleguide_emojis
  get '/styleguide' => 'pages#index', as: :styleguide_main
  get '/styleguide/form-builder' => 'pages#form_builder', as: :styleguide_form_builder
  get '/styleguide/examples/*example_path' => 'examples#show', as: :styleguide_example
  get '/styleguide/emojis' => 'pages#emojis', as: :styleguide_emojis
  get '/styleguide/layouts' => 'layouts#index', as: :layouts
  get '/styleguide/layouts/center-aligned' => 'layouts#center_aligned', as: :layouts_center_aligned
end