module Braspag
  class CreditCard
    attr_accessor :soap_adapter, :response_handler

    def initialize(soap_adapter = SavonAdapter, response_handler = ResponseHandler.new)
      @soap_adapter = soap_adapter
      @response_handler = response_handler
    end

    def self.get(params)
      Braspag::CreditCard.new.get(params)
    end

    def self.save(params)
      Braspag::CreditCard.new.save(params)
    end

    def get(params)
      request = Request.new(Braspag.credit_card_wsdl, :get_credit_card, build_params("getCreditCardRequestWS", params)) do |request| 
        request.on_success {|response| response_handler.get_credit_card(response) }
        request.on_failure {|response| response_handler.handle_error(response) }
      end

      request.call
    end

    def save(params)
      request = Request.new(Braspag.credit_card_wsdl, :save_credit_card, build_params("saveCreditCardRequestWS", params)) do |request| 
        request.on_success {|response| response_handler.save_credit_card(response) }
        request.on_failure {|response| response_handler.handle_error(response) }
      end

      request.call
    end

    private

    def build_params(root_key, params)
      params.merge! "MerchantKey" => Braspag.merchant_key
      { root_key => params }
    end
  end
end
