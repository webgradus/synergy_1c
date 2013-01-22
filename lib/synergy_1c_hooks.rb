class Synergy1cHooks < Spree::ThemeSupport::HookListener
  # custom hooks go here
  insert_after :admin_product_form_right, "admin/shared/code_1c_fields"
  insert_after :admin_variant_edit_form, "admin/shared/code_1c_fields"
  replace :admin_orders_index_row_actions, "admin/shared/order_actions"
end
