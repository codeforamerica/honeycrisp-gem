Rails.application.routes.draw do
  mount Cfa::Styleguide::Engine => "/cfa"
  get '/', to: redirect('/cfa/styleguide')
end
