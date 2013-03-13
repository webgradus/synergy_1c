require 'net/ftp'
Admin::OrdersController.class_eval do
    def export
        if (Spree::Config[:ftp_host].blank? || Spree::Config[:ftp_login].blank?)
            flash[:error] = t(:ftp_error)
            redirect_to admin_orders_path
        else
        f = File.new('xml/' + @order.number + '.xml','w')
        f.puts('<?xml version="1.0" encoding="utf-8" standalone="no"?>')
        f.print('<DSOrders>')

        f.print('<ORDER NUMBER="'+@order.number+'" DATE="' + @order.completed_at.strftime("%Y-%m-%d %H:%M:%S") + '" CLIENT_PHONE="'+ @order.ship_address.phone+'" CLIENT_ADDRESS="'+@order.ship_address.address1 + '"></ORDER>')
        @order.line_items.each do |item|
        if item.quantity > 0

            f.print('<goods good_1s="')
            if (item.variant.code_1c.nil?)
                f.print(item.product.code_1c.nil? ? "no_kod_1c" : item.product.code_1c )
            else
                f.print(item.variant.code_1c)
            end
            f.print('" good_count="')
            f.print(item.quantity.to_s)
            f.print('"></goods>')
        end
        end
        f.puts
        f.print('</DSOrders>')
        f.close


        begin
                ftp = Net::FTP.open(Spree::Config[:ftp_host],Spree::Config[:ftp_login],Spree::Config[:ftp_password])
                ftp.put(f.path)
                File.delete('../../shared/' + f.path)
                ftp.close
                redirect_to admin_orders_path, :notice => t(:succesful_export)
        rescue

                File.delete('../../shared/' + f.path)
                flash[:error] = t(:ftp_error)
                redirect_to admin_orders_path
        end

        end
    end

    def destroy
        @order = Order.find(params[:id])
        @order.destroy
        redirect_to admin_orders_path
    end
end
