require 'net/http'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module MollieIdeal
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          def complete?
            true
          end

          def item_id
            params['item_id']
          end

          def transaction_id
            params['transaction_id']
          end

          # the money amount we received in X.2 decimal.
          def gross
            BigDecimal.new(gross_cents) / 100
          end

          def gross_cents
            params['amount']
          end

          def status
            params['payed'] == 'true' ? 'Completed' : 'Failed'
          end

          def currency
            params['currency']
          end

          def acknowledge(authcode = nil)
            url = "#{MOLLIE_IDEAL_API_URL}?a=check&partnerid=#{CGI.escape(@options[:credential1])}&transaction_id=#{CGI.escape(transaction_id)}"
            response = ssl_get(url)

            xml = REXML::Document.new(response)
            pp response
            params['amount'] = REXML::XPath.first(xml, "//amount").text.to_i
            params['payed'] = REXML::XPath.first(xml, "//payed").text
            params['currency'] = REXML::XPath.first(xml, "//currency").text
            params['consumer_name'] = REXML::XPath.first(xml, "//consumerName").try(:text)
            params['consumer_account'] = REXML::XPath.first(xml, "//consumerAccount").try(:text)
            params['consumer_city'] = REXML::XPath.first(xml, "//consumerCity").try(:text)
            params['message'] = REXML::XPath.first(xml, "//message").try(:text)
            params['status'] = REXML::XPath.first(xml, "//status").try(:text)

            params['status_message'] != 'CheckedBefore'
          end

          private

          def ssl_get(url)
            uri = URI.parse(url)
            site = Net::HTTP.new(uri.host, uri.port)
            site.use_ssl = true
            site.verify_mode    = OpenSSL::SSL::VERIFY_NONE
            site.get(uri.to_s).body
          end
        end
      end
    end
  end
end
