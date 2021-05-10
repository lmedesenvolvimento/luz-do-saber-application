Rails.application.routes.draw do
  resources :user_games

  authenticated :user do
    root to: 'home#index'
  end

  unauthenticated :user do
    devise_scope :user do
      get '/', to: 'devise/sessions#new'

      get '/cadastro/aluno', to: 'users/registrations#new', role: :student, as: :new_student
      get '/cadastro/professor', to: 'users/registrations#new', role: :professor, as: :new_professor
    end
  end

  devise_for :users, controllers: { registrations: 'users/registrations' }

  devise_scope :user do
    get :sair, to: 'devise/sessions#destroy'
  end

  # GAME

  namespace :game do
    post '/user_game',                                          to: 'user_games#create',   defaults: { format: :json }
    get '/user_game/me/:code',                                  to: 'user_games#me',   defaults: { format: :json }

    get '/',                                                    to: 'modulos#index',    defaults: { format: :json }, as: :modulos
    get '/all',                                                 to: 'modulos#all',      defaults: { format: :json }, as: :all
    get '/:modulo_slug',                                        to: 'themes#index',     defaults: { format: :json }, as: :themes
    get '/:modulo_slug/:theme_slug',                            to: 'units#index',      defaults: { format: :json }, as: :units
    get '/:modulo_slug/:theme_slug/:unit_slug',                 to: 'questions#index',  defaults: { format: :json }, as: :questions
    get '/:modulo_slug/:theme_slug/:unit_slug/:question_order', to: 'questions#show',   defaults: { format: :json }, as: :question
  end

  # GAME

  namespace :question do
    resources :types
    resources :item_templates
    resources :titles
    resources :descriptions
    resources :templates, controller: 'question_templates' do
      get :list, on: :collection
    end

    resources :questions do
      put :publish, on: :member
      put :archive, on: :member
      resources :items, controller: 'questions_items'
    end
  end

  resources :themes do
    resources :units
  end
  resources :units
  resources :theme_audiences

  resources :groups do
    resources :participants, controller: :groups_participants
  end

  resources :words
  resources :karaokes
  resources :books

  namespace :admin do
    resources :users
  end

  namespace :professor do
    resources :students
  end

  get '/pages/*id' => 'pages#show', as: :page, format: false
end
