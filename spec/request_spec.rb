require "spec_helper"

describe Braspag::Request do
  describe ".call" do
    let(:params) { {:foo => 'bar'} }
    let(:wsdl_url) { 'server.com?wsdl' }
    let(:action) { :get_credit_card }
    let(:request_block) do
        ->(request) do
        request.on_success &lambda{|response| response}
        request.on_failure &lambda{|response| response}
      end
    end


    it "delegates the call method to soap_adapter" do
      soap_adapter = mock('soap_adapter')
      request = described_class.new(wsdl_url, action, params, soap_adapter){|request| request.on_success {}}
      soap_adapter.should_receive(:call).with(wsdl_url, action, params).and_return(stub(:success? => true))
      request.call
    end

    it "call the success_callback when the response is true" do
      soap_adapter = double('soap_adapter', :call => (response = double('response', :success? => true)))
      request = described_class.new(wsdl_url, action, params, soap_adapter, &request_block)
      request.call.should == response
    end

    it "call the failure_callback when the response is false" do
      soap_adapter = double('soap_adapter', :call => (response = double('response', :success? => false)))
      request = described_class.new(wsdl_url, action, params, soap_adapter, &request_block)
      request.call.should == response
    end
  end
end
