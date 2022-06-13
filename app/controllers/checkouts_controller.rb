class CheckoutsController < ApplicationController

  # enter API credentials below
  def gateway
    gateway = Braintree::Gateway.new(
      :environment => :sandbox,
      :merchant_id => "fs5wp6qdc238xcwf",
      :public_key => "5gz8f2yhmcy3hj4r",
      :private_key => "c07e7d8b020484b8739f2cd688604129",
    )
  end

  def show

  end


  def index

  end

  def new
    @client_token = gateway.client_token.generate
  end

  def create
    @nonce = params["payment_method_nonce"]

    result = gateway.customer.create(
      :payment_method_nonce => @nonce,
      :credit_card => {
        :options => {
          :verify_card => true
        }
      }
    )
    result = gateway.transaction.sale(
      :amount => "10.00",
      :payment_method_token => result.customer.payment_methods[0].token,
      :options => {
        :submit_for_settlement => true
      }
    )

    if result.success?
      flash[:notice] = "Transaction was created successfully!"
      redirect_to checkouts_path
    else
      flash[:error] = result.errors
      render 'new'
    end
    # create if else clause to determine if the above call worked, notify 
    # the user of its success and redirect
  end
end