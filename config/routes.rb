Rails.application.routes.draw do

  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search

  resources :sessions
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout
  # Resource routes (maps HTTP verbs to controller actions automatically):
  resources :employees
  resources :stores
  resources :assignments

  resources :shifts
  resources :jobs
  resources :shift_jobs
  resources :jobs
  resources :pay_grades
  resources :pay_grade_rates


  # Custom routes
  patch 'assignments/:id/terminate', to: 'assignments#terminate', as: :terminate_assignment

  get 'stores/:id/payroll', to: 'payrolls#store_pay_form', as: :store_payroll
  get 'employees/:id/payroll', to: 'payrolls#emp_pay', as: :employee_payroll
  post 'payrolls', to: 'payrolls#store_calc', as: :store_calc
  get 'payrolls', to: 'payrolls#store_calc', as: :calc_store

  patch 'home/clock_in', to: 'home#clock_in', as: :clock_in
  patch 'home/clock_out', to: 'home#clock_out', as: :clock_out

  # You can have the root of your site routed with 'root'
  root 'home#index'
end
