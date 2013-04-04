require "ostruct"
module Braspag
  class SavonAdapter
    def self.call(wsdl_url, action, params)
      client = Savon.client(wsdl: wsdl_url, pretty_print_xml: true)
      response = client.call(action, message: params)

      rescue Savon::SOAPFault => error
        OpenStruct.new(:success? => false, :fault => error.to_hash[:fault])
      rescue StandardError => error
        OpenStruct.new(:success? => false, :fault => {:faultstring => error.message})
    end
  end
end
