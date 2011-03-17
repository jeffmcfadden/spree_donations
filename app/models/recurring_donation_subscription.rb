# Authorize.net api params:
# refId
# subscription
#   name
#   paymentSchedule
#     interval
#       length
#       unit
#     startDate
#     totalOccurrences
#     trialOccurrences
#   amount
#   trialAmount
#   payment
#     creditCard
#       cardNumber
#       expirationDate
#       cardCode
#     bankAccount
#       accountType
#       routingNumber
#       accountNumber
#       nameOnAccount
#       echeckType
#       bankName
#   order
#     invoiceNumber
#     description
#   customer
#     id
#     email
#     phoneNumber
#     faxNumber
#
#   billTo
#     firstName
#     lastName
#     company
#     address
#     city
#     state
#     zip
#     country
#   shipTo
#     firstName
#     lastName
#     company
#     address
#     city
#     state
#     zip
#     country
#
#     gateway_subscription_id:integer
#     created_by_order_id:integer
#     variant_id:integer
#     user_id:integer
#     cc_last_4_digits:string
#     amount:float
#     first_name:string
#     last_name:string
#     company:string
#     address:string
#     city:string
#     state:string
#     zip:string
#     country:string
#
#
#
class RecurringDonationSubscription < ActiveRecord::Base

  #Never saved to the DB, you must provide this for Creating/Updating
  #subscription
  attr_accessor :payment_info

  after_save :save_to_gateway

  def cancel
    gateway_cancel_recurring
    status = 'Cancelled'
    save
  end

  def save_to_gateway
    puts 'save_to_gateway'
      
    unless status == 'cancelled' || @updating_gateway == true
      puts 'Actually saving to gateway.'
      @updating_gateway = true
      if status.nil? && ( self.gateway_subscription_id.nil? || self.gateway_subscription_id.blank? )
        gateway_create_recurring
      else
        gateway_update_recurring
      end
      @updating_gateway = false
    end

    true
  end

    def gateway_create_recurring 
      puts 'gateway_create_recurring'
        resp = payment_gateway.recurring( 
            self.amount, 
            self.payment_info,
            {
              :interval => {
                :length => 1,
                :unit   => :months
              },
              :duration => {
                :start_date  => 1.month.from_now.strftime( '%Y-%m-%d' ),
                :occurrences => 999
              },
              :billing_address => {
                :first_name   => self.first_name,
                :last_name    => self.last_name,
                :company      => self.company,
                :address      => self.address,
                :city         => self.city,
                :state        => self.state,
                :zip          => self.zip,
                :country      => self.country 
              }
            }  
        )

        pp resp
        self.update_attribute( 'gateway_subscription_id', resp.authorization )

        if resp.success?
          self.update_attribute( 'status', 'active' )
        else
          self.update_attribute( 'status', 'Error: ' + resp.message )
        end
    end

    def gateway_update_recurring 
        resp = payment_gateway.update_recurring( {
            :subscription_id  => self.gateway_subscription_id,
            :credit_card      => self.payment_info,
            :amount           => self.amount,
            :billing_address => {
              :first_name   => self.first_name,
              :last_name    => self.last_name,
              :company      => self.company,
              :address      => self.address,
              :city         => self.city,
              :state        => self.state,
              :zip          => self.zip,
              :country      => self.country 
            }
        })
        true
    end

    def gateway_cancel_recurring
        payment_gateway.cancel_recurring( self.gateway_subscription_id )
    end
    
    def payment_gateway
        @payment_gateway ||= Gateway.current.provider
    end
end
