Order.class_eval do

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

            if l.variant.product.is_recurring?
              sub = RecurringDonationSubscription.new
              sub.first_name    = self.bill_address.firstname
              sub.last_name     = self.bill_address.lastname
              sub.address       = self.bill_address.address1
              sub.city          = self.bill_address.city
              sub.state         = self.bill_address.state
              sub.zip           = self.bill_address.zipcode
              sub.country       = self.bill_address.country
              sub.payment_info  = cc
              sub.amount        = l.price
              sub.save
            end
          end
        end
        
        ret
    end

    alias_method :original_finalize!, :finalize!
    alias_method :finalize!, :finalize_and_add_any_arbs

    alias_method :original_process_payments!, :process_payments!
    alias_method :process_payments!, :process_payments_and_create_arbs

end
