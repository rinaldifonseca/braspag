require "spec_helper"

describe Braspag::CreditCard do
  let(:save_params) do
    {"CustomerIdentification" => "cli0001",
     "CustomerName" => "Joao",
     "CardHolder" => "Joao",
     "CardNumber" => 0000000000000001,
     "CardExpiration" => "09/2017",
     "JustClickAlias" => "alias"}
  end

  describe ".save" do
    let(:expected_success_data) do
      {:success=>true,
       :correlation_id=>nil,
       :just_click_key=>"b66b18cd-8036-46be-91c4-b1e91f318a76"}
    end

    it "returns the expected data" do
      VCR.use_cassette('credit_card') do
        response = Braspag::CreditCard.save save_params
        response.data.should == expected_success_data
      end
    end


    it "returns success? true" do
      VCR.use_cassette('credit_card') do
        response = Braspag::CreditCard.save save_params
        response.success?.should eql(true)
      end
    end
  end

  describe ".get" do
    let(:expected_success_data) do
      {:success=>true,
       :correlation_id=>nil,
       :card_holder=>"JOAO",
       :card_number=>"1",
       :card_expiration=>"09/2017",
       :masked_card_number=>"1"}
    end

    let(:just_click_key) { Braspag::CreditCard.save(save_params).data[:just_click_key] }
    subject { Braspag::CreditCard.get("JustClickKey" => just_click_key) }

    it "returns the expected data" do
      VCR.use_cassette('credit_card') do
        subject.data.should == expected_success_data
      end
    end

    it "returns success? true" do
      VCR.use_cassette('credit_card') do
        subject.success?.should be_true
      end
    end
  end
end
