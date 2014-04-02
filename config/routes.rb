ActionController::Routing::Routes.draw do |map|
map.feed 'final_bills/insurance_index', :controller =>'final_bills', :action =>'insurance_index'
map.resources :registrations, :only => [:index, :show, :new, :create, :edit], :new => { :upload => :post }

  map.resources :drug_formulas
  map.resources :refferal_masters

  map.resources :consultant_visit_children

  map.resources :pharmacy_ranges
  
  map.resources :miscellaneous_masters
  
  map.resources :test_cancels
  
  map.resources :insurance_masters
  
  map.resources :reports
  
  map.resources :insurance_payments
  
  map.resources :package_master_majestics
  
  map.resources :pakage_transfers
  
  map.resources :dashboards
  
  map.resources :notice_boards
  
  map.resources :calculate
  
  map.resources :complaints
  
  map.resources :numbers
  
  map.resources :store_test_results
  
  map.resources :number_masters

  map.resources :test_booking_children

  map.resources :test_bookings
  
  map.resources :profilemasters
  
  map.resources :org_masters

  map.resources :numbers
  
  map.resources :modules_lists

  map.resources :admissions

  map.resources :treatment_plans

 

  map.resources :bed_masters

  map.resources :agency_masters

  map.resources :charge_master_children

  map.resources :charge_masters

  map.resources :itemmasters

  map.resources :manufacturers

  map.resources :testmaster_children

  map.resources :testmasters
  map.resources :servicemasters
  map.root :controller => 'sessions'
 
  map.resources :people
  map.resources :sessions
  map.resources :consultant_masters
  map.resources :employee_masters
  map.resources :department_masters
  map.resources :itemmasters
  map.resources :manufacturers
  map.resources :country_masters
  map.resources :state_masters
  map.resources :city_masters
  map.resources :ward_masters
  map.resources :room_masters
  map.resources :bed_masters
  map.resources :consultant_visits
  map.resources :appointment_payments
  map.resources :discharge_summaries
  map.resources :ip_dues
  map.resources :advance_payments
  map.resources :dues
  map.resources :goodsrecieptnotemasters
  map.resources :purchaseordermasters
  map.resources :issues_to_ops
  map.resources :op_patient_returns
  map.resources :stock_transfers
  map.resources :stock_returns
  map.resources :purchase_order_returns
  map.resources :pharmacy_payments
  map.resources :goods_received_for_ots
  map.resources :store_children
  map.resources :bed_managements
  map.resources :bed_transfers
  map.resources :final_bills
  map.resources :final_bill_cancels
  map.resources :client_lists
  map.resources :store_radiology_tests

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
