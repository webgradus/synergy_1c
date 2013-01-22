Admin::OrdersController.class_eval do
    def export
        f = File.new('xml/' + @order.number + '.xml','w')
        f.puts('<?xml version="1.0" encoding="windows-1251" standalone="no"?>')
        f.puts('<DSOrders>')

        f.puts('<ORDER NUMBER="'+@order.number+'" DATE="' + @order.created_at.to_s + '" CLIENT_PHONE="'+ @order.ship_address.phone+'" CLIENT_ADDRESS="'+@order.ship_address.address1 + '"></ORDER>')
        @order.line_items.each do |item|
            f.print('<goods good_1s="')
            if (Variant.find_by_id(item.variant_id).code_1c.nil?)
                f.print(Product.find_by_id(Variant.find_by_id(item.variant_id).product_id).code_1c.nil? ? "no_kod_1c" : Product.find_by_id(Variant.find_by_id(item.variant_id).product_id).code_1c.to_s )
            else
                f.print(Variant.find_by_id(item.variant_id).code_1c.to_s)
            end
            f.print('" good_count="')
            f.print(item.quantity.to_s)
            f.print('"></goods>')
        end
        f.puts('</DSOrders>')
        f.close
        redirect_to admin_orders_path, :notice => t(:succesful_export)
    end
end
