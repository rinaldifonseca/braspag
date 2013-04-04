module Braspag
  class PaymentDataRequestXML
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def to_s
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.root('xmlns:tns' => 'type') do
          xml['tns'].PaymentDataRequest('xsi:type' => "tns:CreditCardDataRequest") { 
            xml['tns'].PaymentMethod params["PaymentMethod"]
            xml['tns'].Amount params["Amount"]
            xml['tns'].Country params["Country"]
            xml['tns'].Currency params["Currency"]
            xml['tns'].ServiceTaxAmount params["ServiceTaxAmount"] if params["ServiceTaxAmount"]
            xml['tns'].NumberOfPayments params["NumberOfPayments"] if params["NumberOfPayments"]
            xml['tns'].PaymentPlan params["PaymentPlan"] if params["PaymentPlan"]
            xml['tns'].TransactionType params["TransactionType"] if params["TransactionType"]
            xml['tns'].CardHolder params["CardHolder"] if params["CardHolder"]
            xml['tns'].CardNumber params["CardNumber"] if params["CardNumber"]
            xml['tns'].CardSecurityCode params["CardSecurityCode"] if params["CardSecurityCode"]
            xml['tns'].CardExpirationDate params["CardExpirationDate"] if params["CardExpirationDate"]
            xml['tns'].CreditCardToken params["CreditCardToken"] if params["CreditCardToken"]
            xml['tns'].JustClickAlias params["JustClickAlias"] if params["JustClickAlias"]
            xml['tns'].SaveCreditCard params["SaveCreditCard"] if params["SaveCreditCard"]
          }
        end
      end
      builder.doc.root.elements.first.to_xml
    end
  end
end
