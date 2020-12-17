Cfa::Styleguide::Engine.routes.draw do
  get "/styleguide" => "pages#index", as: :styleguide_main
  get "/styleguide/form-builder" => "pages#form_builder", as: :styleguide_form_builder
  get "/styleguide/examples/*example_path" => "examples#show", as: :styleguide_example
  get "/styleguide/emojis" => "pages#emojis", as: :styleguide_emojis
  get "/styleguide/honeycrisp-compact" => "pages#honeycrisp_compact", as: :styleguide_honeycrisp_compact
end
