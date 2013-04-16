require_relative "spec_helper"

describe Braspag::Transaction do
  let(:save_params) do
    {"OrderId" => "order98787#{rand(1000)}",
     "CustomerIdentity" => "cli0002",
     "CustomerName" => "Joao de Teste",
     "CustomerEmail" => "joao@test.com",
     "CreditCardToken" => "abc123",
     "Street" => "Rua Exemplo",
     "ZipCode" => "04112002",
     "PaymentMethod" => 997,
     "Amount" => 180,
     "NumberOfPayments" => 1,
     "TransactionType" => 1,
     "Currency" => "BRL",
     "Country" => "BRA"}
  end

  describe ".authorize" do
    let(:expected_success_data) do
      {:braspag_transaction_id=>"d1e74043-1ae1-4de6-ba4e-a34aaaf5cd8a",
       :payment_method=>"997",
       :amount=>"180",
       :acquirer_transaction_id=>"0403102700500",
       :authorization_code=>"938899",
       :return_code=>"4",
       :return_message=>"Operation Successful",
       :status=>"1",
       :credit_card_token=>"d94ad4a1-4c21-41e2-a63f-438e472cbbcf",
       :"@xsi:type"=>"CreditCardDataResponse",
       :order_id=>"order98787174",
       :braspag_order_id=>"d0e184a9-ecdb-417e-8a28-7d3b29a4d112"}
    end

    it "returns success? true" do
      VCR.use_cassette('transaction') do
        response = Braspag::Transaction.authorize save_params
        response.success?.should eql(true)
      end
    end

    it "returns the expected data" do
      VCR.use_cassette('transaction') do
        response = Braspag::Transaction.authorize save_params
        response.data.should == expected_success_data
      end
    end
  end

  describe ".capture" do
    let(:expected_success_data) do
      {:braspag_transaction_id=>"d1e74043-1ae1-4de6-ba4e-a34aaaf5cd8a",
       :acquirer_transaction_id=>"0403102700500",
       :amount=>"180",
       :authorization_code=>"20130403102702984",
       :return_code=>"6",
       :return_message=>"Operation Successful",
       :status=>"0"}
    end

    it "returns the expected data" do
      VCR.use_cassette('transaction') do
        braspag_transaction_id = Braspag::Transaction.authorize(save_params).data.fetch :braspag_transaction_id
        response = Braspag::Transaction.capture("BraspagTransactionId" => braspag_transaction_id, "Amount" => 180)
        response.data.should == expected_success_data
      end
    end
  end
end
