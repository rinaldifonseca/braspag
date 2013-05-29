require "ostruct"
module Braspag
  class SavonAdapter
    def self.call(wsdl_url, action, params)
      log = Braspag.logging ? true : false
      client = Savon.client(wsdl: wsdl_url, pretty_print_xml: true, log: log)
      response = client.call(action, message: params)

      rescue Savon::SOAPFault => error
        OpenStruct.new(:success? => false, :fault => error.to_hash[:fault])
      rescue StandardError => error
        OpenStruct.new(:success? => false, :fault => {:faultstring => error.message})
    end
  end
end
