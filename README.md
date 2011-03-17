SpreeDonations
===============

Allows you to offer donations within your spree store. 


Installation
============

Need to fill this out.


How Donations Are Modeled
=========================

Donations are built as products with the following special properties:
    
    is_donation    #This product is a donation
    is_recurring   #This donation is a recurring donation and a subscription
                   #should be built for it

Each product has two new methods to make it easy to test for these:
  
    is_donation?
    is_recurring?

Pricing
-------
Donation products should be priced at $1.00


**Currently the extension does not build these properties for you. A future
release will include generation of these properties and potentially some
generators for creating new donations and donation types**

How Quantity/Price Is Handled
=============================

Throughout the backend, donations are set to have a price of $1.00. When
a donation is added to the cart, the qty field is used so that the cart total
will match the intended giving amount.

For example, the user wants to donate $25. The user enters "25" in the qty
field, and the system proceeds through the checkout process with a total
donation of 25 * $1 = $25.

Once the order has been completed, the line item is transformed and the price
of that line item is the total, with a quantity of 1. This means that you can
reliabily use the qty field to pull reports on the number of donations, etc.

    #After order is complete:
    line_item.find( my_donation_id )
    line_item.quantity
    > 1
    
    line_item.price
    > 25


Recurring Donations
===================

Prerequisites
-------------
You must be using a gateway that supports ARB subscriptions via ActiveMerchant. 
Authorize.net is known to support these, among a few others.

ARB subscriptions are created upon completion of an order, once payment of the
order total has been successful.




Credits
=======

Copyright (c) 2011 Desiring God Ministries, released under the New BSD License
