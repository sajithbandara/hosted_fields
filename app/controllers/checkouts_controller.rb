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
    @transaction = gateway.transaction.find(params[:id])
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
    if result.success?
      result = gateway.transaction.sale(
        :amount => "10.00", # make dynamic
        :payment_method_token => result.customer.payment_methods[0].token,
        :options => {
          :submit_for_settlement => true
        }
      )

      if result.success?
        redirect_to checkout_path(result.transaction.id)
      else
        #flash[:error] = result.errors
        #render 'new'
        redirect_to new_checkout_path
      end
    else
      #flash[:notice] = error_messages
      redirect_to new_checkout_path
    end
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