Rails.application.routes.draw do
  # Add your extension routes here
    namespace :admin do
        resource :synergy1c
    end
 match 'admin/export_order/:id' => 'admin/orders#export', :as => :export
end
