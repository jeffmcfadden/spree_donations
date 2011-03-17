OrdersController.class_eval do
  
    def populate_with_support_for_donations
        logger.info "populate_with_support_for_donations"
        populate_orig
        return 

        if something
            populate_orig( params )
        end

        @order = current_order(true)

        params[:products].each do |product_id,variant_id|
            quantity = params[:quantity].to_i if !params[:quantity].is_a?(Hash)
            quantity = params[:quantity][variant_id].to_i if params[:quantity].is_a?(Hash)
            @order.add_variant(Variant.find(variant_id), quantity) if quantity > 0
        end if params[:products]

        params[:variants].each do |variant_id, quantity|
            quantity = quantity.to_i
            @order.add_variant(Variant.find(variant_id), quantity) if quantity > 0
        end if params[:variants]

        redirect_to cart_path
    end
    

    #alias_method :populate_orig, :populate
    #alias_method :populate, :populate_with_support_for_donations                                                                                                                                 
end

