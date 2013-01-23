require 'net/ftp'
Admin::OrdersController.class_eval do
    def export
        f = File.new('xml/' + @order.number + '.xml','w')
        f.puts('<?xml version="1.0" encoding="utf-8" standalone="no"?>')
        f.puts('<DSOrders>')

        f.puts('<ORDER NUMBER="'+@order.number+'" DATE="' + @order.created_at.strftime("%Y-%m-%d %H:%M:%S") + '" CLIENT_PHONE="'+ @order.ship_address.phone+'" CLIENT_ADDRESS="'+@order.ship_address.address1 + '"></ORDER>')
        @order.line_items.each do |item|
            f.print('<goods good_1s="')
            variant = Variant.find_by_id(item.variant_id)
            if (variant.code_1c.nil?)
                product_code = Product.find_by_id(variant.product_id).code_1c
                f.print(product_code.nil? ? "no_kod_1c" : product_code )
            else
                f.print(Variant.find_by_id(item.variant_id).code_1c)
            end
            f.print('" good_count="')
            f.print(item.quantity.to_s)
            f.print('"></goods>')
        end
        f.puts('</DSOrders>')
        f.close

        ftp = Net::FTP.open()
        ftp.put(f.path)
        File.delete(f.path)
        ftp.close

        redirect_to admin_orders_path, :notice => t(:succesful_export)
    end
end
