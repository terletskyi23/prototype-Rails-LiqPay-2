class PaymentsController < ApplicationController
  protect_from_forgery :except => :liqpay_payment

  def liqpay_payment
    @liqpay_response = Liqpay::Response.new(params)
    #@order = Order.find(@liqpay_response.order_id)
    @order = Order.first

    @order.data = {}

    (Liqpay::Response::ATTRIBUTES - %w(public_key sender_phone transaction_id)).each do |attribute|
      @order.data[attribute] = @liqpay_response.send(attribute)
    end

    p "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    if @liqpay_response.success?
      p "success"
      @order.update_attributes!(paid: true)
    else
      p "failed"
      @order.update_attributes!(paid: true)
    end
    p "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"

    redirect_to @order
  rescue Liqpay::InvalidResponse
    render text: 'Payment error', status: 500
  end
end
