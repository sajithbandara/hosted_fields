class CheckoutsController < ApplicationController

  def show

  end

  # enter API credentials below
  def gateway
    gateway = Braintree::Gateway.new(
      :environment => :sandbox,
      :merchant_id => "fs5wp6qdc238xcwf",
      :public_key => "5gz8f2yhmcy3hj4r",
      :private_key => "c07e7d8b020484b8739f2cd688604129",
    )
  end

  # pass client_token to your front-end
  def new
    @client_token = gateway.client_token.generate(
    #:customer_id => a_customer_id
    )
  end
end