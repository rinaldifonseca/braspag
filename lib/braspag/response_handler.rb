module Braspag
  class ResponseHandler
    def authorize_transaction(response)
      data = response.body[:authorize_transaction_response][:authorize_transaction_result]
      if data[:success]
        payment_data_response = data[:payment_data_collection][:payment_data_response]
        status =  payment_data_response[:status]
        if status == "1" || status == "2"
          OpenStruct.new(:success? => true, :data => payment_data_response.merge(data[:order_data]))
        else
          OpenStruct.new(:success? => false, :error_code => payment_data_response[:return_code], :error_message => payment_data_response[:return_message])
        end
      else
        error_report = data[:error_report_data_collection][:error_report_data_response]
        OpenStruct.new(:success? => false, :error_code => error_report[:error_code], :error_message => error_report[:error_message])
      end
    end

    def capture_transaction(response)
      data = response.body[:capture_credit_card_transaction_response][:capture_credit_card_transaction_result]
      if data[:success]
        data_collection = data[:transaction_data_collection][:transaction_data_response]
        if data_collection[:status] == "0"
          OpenStruct.new(:success? => true, :data => data_collection)
        else
          OpenStruct.new(:success? => false, :error_code => data_collection[:return_code], :error_message => data_collection[:return_message])
        end
      else
        error_report = data[:error_report_data_collection][:error_report_data_response]
        OpenStruct.new(:success? => false, :error_code => error_report[:error_code], :error_message => error_report[:error_message])
      end
    end

    def get_credit_card(response)
      data = response.body[:get_credit_card_response][:get_credit_card_result]
      if data[:success]
        OpenStruct.new(:success? => true, :data => data)
      else
        error_report = data[:error_report_collection][:error_report]
        OpenStruct.new(:success? => false, :error_code => error_report[:error_code], :error_message => error_report[:error_message])
      end
    end

    def save_credit_card(response)
      data = response.body[:save_credit_card_response][:save_credit_card_result]
      if data[:success]
        OpenStruct.new(:success? => true, :data => data)
      else
        error_report = data[:error_report_collection][:error_report]
        OpenStruct.new(:success? => false, :error_code => error_report[:error_code], :error_message => error_report[:error_message])
      end
    end

    def handle_error(response)
      fault = response.fault
      OpenStruct.new(:success? => false, :error_code => fault[:faultcode], :error_message => fault[:faultstring])
    end
  end
end
