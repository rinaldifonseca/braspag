module Braspag
  class Request 
    attr_accessor :soap_adapter, :success_callback, :failure_callback

    def initialize(wsdl_url, action, params, soap_adapter = SavonAdapter)
      @wsdl_url, @action, @params = wsdl_url, action, params
      @soap_adapter = soap_adapter
      yield self
    end

    def call
      response = soap_adapter.call(@wsdl_url, @action, @params)
      response.success? ? success_callback.call(response) : failure_callback.call(response)
    end

    def on_success(&block)
      self.success_callback = block
    end

    def on_failure(&block)
      self.failure_callback = block
    end
  end
end
