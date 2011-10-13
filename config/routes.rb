Register::Application.routes.draw do
  resources :ledgers do
    collection do
      get :search
    end

    member do
      get :graphs
      get :payees
      get :category_list
      get :last_category
      get :initial_data
    end

    resources :entries
    resources :recurring_entries
  end

  resource :chart

  root :to => "ledgers#show"
end
