Order.class_eval do
  # TODO: Change item_count to be this?
  def item_count_handling_donations
    line_items.map do |line_item|
      if line_item.variant.product.is_donation?
        1
      else
        line_item.quantity
      end
    end.sum
  end

    def finalize_and_add_any_arbs
        self.original_finalize!
      
        #Iterate over line items
        #Adjust any donations to have propery quantity/price values

        #Iterate over line items.
        #If we find a recurring donation
        #then setup a new arb, using the same CC info that
        #we just used to process this order
    end

    #We have to inject ourselves here because if we wait until longer there
    #won't be any CC info to use - it gets thrown away with the payment goes
    #away
    def process_payments_and_create_arbs
        #This should throw an error if there's an issue
        #so we aren't doing any wrapping or checking.
        ret = self.original_process_payments!

        cc = self.payments.first

        line_items.each do |l|
          if l.variant.product.is_donation?
            l.price     = l.quantity
            l.quantity  = 1
            l.save
          end
        end
        
        ret
    end

    alias_method :original_finalize!, :finalize!
    alias_method :finalize!, :finalize_and_add_any_arbs

    alias_method :original_process_payments!, :process_payments!
    alias_method :process_payments!, :process_payments_and_create_arbs

end
