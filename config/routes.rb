Cfa::Styleguide::Engine.routes.draw do
  get "/styleguide" => "pages#index", as: :styleguide_main
  get "/styleguide/form-builder/v1" => "pages#form_builder_v1", as: :styleguide_form_builder_v1
  get "/styleguide/form-builder/v2" => "pages#form_builder_v2", as: :styleguide_form_builder_v2
  get "/styleguide/examples/*example_path" => "examples#show", as: :styleguide_example
  get "/styleguide/emojis" => "pages#emojis", as: :styleguide_emojis
  get "/styleguide/honeycrisp-compact" => "pages#honeycrisp_compact", as: :styleguide_honeycrisp_compact
end
