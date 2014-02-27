module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module MollieIdeal
        class Helper < ActiveMerchant::Billing::Integrations::Helper

          # https://secure.mollie.nl/xml/ideal?a=fetch&partnerid=1487031&bank_id=9999&testmode=true&amount=123&description=test&reporturl=http%3A%2F%2Fwww.example.org%2Freport.php&returnurl=http%3A%2F%2Fwww.example.org%2Freturn.php

          def initialize(order, account, options = {})
            super

            if ActiveMerchant::Billing::Base.integration_mode == :test || options[:test]
              add_field('testmode', 'true')
            end
          end

          def form_method
            "GET"
          end

          # Replace with the real mapping
          mapping :account, 'partnerid'
          mapping :amount, 'amount'
          mapping :order, 'transaction_id'
          mapping :notify_url, 'reporturl'
          mapping :return_url, 'returnurl'
          mapping :cancel_return_url, 'returnurl'
          mapping :description, 'description'
        end
      end
    end
  end
end
