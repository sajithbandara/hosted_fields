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
    @transactions = gateway.transaction.search do |search|
      search.created_at >= 90.days.ago
    end
    # calculate the total for successful transactions
    @total = 0
    @transactions.each do |transaction|
      if TRANSACTION_SUCCESS_STATUSES.include? transaction.status
      @total += transaction.amount
      end
    end
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

  TRANSACTION_SUCCESS_STATUSES = [
    Braintree::Transaction::Status::Authorizing,
    Braintree::Transaction::Status::Authorized,
    Braintree::Transaction::Status::Settled,
    Braintree::Transaction::Status::SettlementConfirmed,
    Braintree::Transaction::Status::SettlementPending,
    Braintree::Transaction::Status::Settling,
    Braintree::Transaction::Status::SubmittedForSettlement,
  ]
end