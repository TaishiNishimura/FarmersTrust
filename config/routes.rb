Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :customers, controllers: {
    sessions: 'public/sessions',
    registrations: 'public/registrations',
  }
  scope module: :public do
    root to: 'homes#top'
    get 'about' => 'homes#about'
    get 'unsubscribe' => 'customers#unsubscribe'
    patch 'withdraw' => 'customers#withdraw'
    delete 'destroy_all' => 'cart_items#destroy_all'
    post 'confirm' => 'orders#confirm'
    get 'confirm' => 'orders#error'
    get 'thanks' => 'orders#thanks'
    resources :customers, only: [:show, :edit, :update]
    resources :orders, only: [:new, :create, :index, :show]
    resources :addresses, except: [:new, :show]
    resources :items, only: [:index, :show] do
      resources :cart_items, only: [:create, :update, :destroy]
    end
    resources :cart_items, only: [:index]
    resources :contacts, only: [:new, :create]
    post 'contacts/check', to: 'contacts#check', as: 'check'
    post 'contacts/back', to: 'contacts#back', as: 'back'
    get 'done', to: 'contacts#done', as: 'done'
  end


  devise_for :admin, controllers: {
    sessions: 'admin/sessions',
  }
  namespace :admin do
    get 'top' => 'homes#top', as: 'top'
    resources :items, except: [:destroy]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :customers, only: [:index, :show, :edit, :update]
    resources :orders, only: [:index, :show, :update] do
      resources :order_details, only: [:update]
    end
  end
end

