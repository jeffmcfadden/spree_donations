class CreateRecurringDonationSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :recurring_donation_subscriptions do |t|

      t.float   :amount
      t.string  :gateway_subscription_id
      t.string  :status
      t.integer :created_by_order_id
      t.integer :variant_id
      t.integer :user_id
      t.string  :cc_last_4_digits
      t.integer :cc_exp_month
      t.integer :cc_exp_year
      t.string  :first_name
      t.string  :last_name
      t.string  :company
      t.string  :address
      t.string  :city
      t.string  :state
      t.string  :zip
      t.string  :country

      t.timestamps
    end
  end

  def self.down
    drop_table :recurring_donation_subscriptions
  end
end
