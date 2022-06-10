class CheckoutsController < ApplicationController

  def show

  end

  # enter API credentials below
  def gateway
    gateway = Braintree::Gateway.new(
      :environment => :sandbox,
      :merchant_id => "use_your_merchant_id",
      :public_key => "use_your_public_key",
      :private_key => "use_your_private_key",
    )
  end

end