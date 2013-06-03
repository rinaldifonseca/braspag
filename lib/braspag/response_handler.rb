module Braspag
  CAPTURE_TRANSACTION_SUCCESS_STATUS = "0"
  AUTHORIZE_TRANSACTION_SUCCESS_STATUS = ["0", "1"]

  class ResponseHandler
    def authorize_transaction(response)
      data = response.body[:authorize_transaction_response][:authorize_transaction_result]
      if data[:success]
        payment_data_response = data[:payment_data_collection][:payment_data_response]
        status =  payment_data_response[:status]
        if AUTHORIZE_TRANSACTION_SUCCESS_STATUS.include? status
          respond_with_success(payment_data_response.merge(data[:order_data]))
        else
          respond_with_failure(payment_data_response[:return_code], payment_data_response[:return_message])
        end
      else
        respond_with_failure_transaction(data)
      end
    end

    def capture_transaction(response)
      data = response.body[:capture_credit_card_transaction_response][:capture_credit_card_transaction_result]
      if data[:success]
        data_collection = data[:transaction_data_collection][:transaction_data_response]
        if data_collection[:status] == CAPTURE_TRANSACTION_SUCCESS_STATUS
          respond_with_success(data_collection)
        else
          respond_with_failure(data_collection[:return_code], data_collection[:return_message])
        end
      else
        respond_with_failure_transaction(data)
      end
    end

    def get_credit_card(response)
      data = response.body[:get_credit_card_response][:get_credit_card_result]
      credit_card_response_for(data)
    end

    def save_credit_card(response)
      data = response.body[:save_credit_card_response][:save_credit_card_result]
      credit_card_response_for(data)
    end

    def handle_error(response)
      OpenStruct.new(:success? => false, :data => response)
    end

    private

    def respond_with_failure_transaction(data)
      error_report = data[:error_report_data_collection][:error_report_data_response]
      respond_with_failure(error_report[:error_code], error_report[:error_message])
    end

    def credit_card_response_for(data)
      if data[:success]
        OpenStruct.new(:success? => true, :data => data)
      else
        error_report = data[:error_report_collection][:error_report]
        OpenStruct.new(:success? => false, :error_code => error_report[:error_code], :error_message => error_report[:error_message])
      end
    end

    def respond_with_success(data)
      OpenStruct.new(:success? => true, :data => data)
    end

    def respond_with_failure(error_code, error_message)
      OpenStruct.new(:success? => false, :error_code => error_code, :error_message => error_message)
    end
  end
end
