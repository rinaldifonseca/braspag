require "spec_helper"

describe Braspag::ResponseHandler do
  describe ".authorize_transaction" do
    describe "on failure" do
      let(:error_message){ "OrderId is a mandatory parameter" }
      let(:error_code){ "405" }
      let(:body) do
        {:authorize_transaction_response=>
         {:authorize_transaction_result=>
          {:correlation_id=>"5735a1af-d26c-4716-bc8c-11da2990b8f5",
           :success=>false,
           :error_report_data_collection=>
          {:error_report_data_response=>
           {:error_code=> error_code,
            :error_message=> error_message}}},
            :@xmlns=>"https://www.pagador.com.br/webservice/pagador"}}
      end

      let(:failure_response) do
        OpenStruct.new(:body => body)
      end

      it "returns success? false" do
        response = Braspag::ResponseHandler.new.authorize_transaction failure_response
        response.success?.should_not be_true
      end

      it "returns the error_code and error_message" do
        response = Braspag::ResponseHandler.new.authorize_transaction failure_response
        response.error_message.should == error_message
        response.error_code.should == error_code
      end
    end

    describe "on success" do
      let(:payment_data_response) do
        {:braspag_transaction_id=>"d1e74043-1ae1-4de6-ba4e-a34aaaf5cd8a",
         :payment_method=>"997",
         :amount=>"180",
         :acquirer_transaction_id=>"0403102700500",
         :authorization_code=>"938899",
         :return_code=>"4",
         :return_message=>"Operation Successful",
         :status=>"1",
         :credit_card_token=>"d94ad4a1-4c21-41e2-a63f-438e472cbbcf",
         :"@xsi:type"=>"CreditCardDataResponse"}
      end

      let(:authorize_transaction_result) do
        {:correlation_id=>"d014c828-2889-44c3-89e6-39004fc34c90",
         :success=>true,
         :error_report_data_collection=>nil,
         :order_data=>
        {:order_id=>"order98787174",
         :braspag_order_id=>"d0e184a9-ecdb-417e-8a28-7d3b29a4d112"},
         :payment_data_collection=>
        {:payment_data_response=> payment_data_response}}
      end

      let(:body) do
        {:authorize_transaction_response=>
         {:authorize_transaction_result=> authorize_transaction_result,
          :@xmlns=>"https://www.pagador.com.br/webservice/pagador"}}
      end

      let(:success_response) do
        OpenStruct.new(:body => body)
      end

      let(:data) { authorize_transaction_result }
      let(:return_message) { "invalid order id" }
      let(:return_code) { "450" }

      describe "when the transaction status is 1 or 2" do
        it "returns a struct with the transaction data" do
          expected_data = data[:payment_data_collection][:payment_data_response].merge(data[:order_data])
          response = Braspag::ResponseHandler.new.authorize_transaction success_response
          response.data.should == expected_data
        end

        it "returns success true" do
          response = Braspag::ResponseHandler.new.authorize_transaction success_response
          response.success?.should be_true
        end
      end

      describe "when the transaction status is not 1 or 2" do
        before :each do
          payment_data_response[:status] = 3
          payment_data_response[:return_message] = return_message
          payment_data_response[:return_code] = return_code
        end

        it "returns success false" do
          response = Braspag::ResponseHandler.new.authorize_transaction success_response
          response.success?.should_not be_true
        end

        it "returns the error_code and error_message" do
          response = Braspag::ResponseHandler.new.authorize_transaction success_response
          response.error_code.should == return_code
          response.error_message.should == return_message
        end
      end
    end
  end
end
