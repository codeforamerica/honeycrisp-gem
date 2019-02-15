Rails.application.routes.draw do
  mount Cfa::Styleguide::Engine => "/cfa"
  get "/", to: redirect("/cfa/styleguide")
  get "/favicon.ico", to: proc { [200, {}, [""]] }
end
