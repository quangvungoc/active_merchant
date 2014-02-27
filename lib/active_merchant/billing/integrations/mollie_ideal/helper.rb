module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module MollieIdeal
        class Helper < ActiveMerchant::Billing::Integrations::Helper

          # https://secure.mollie.nl/xml/ideal?a=fetch&partnerid=1487031&bank_id=9999&testmode=true&amount=123&description=test&reporturl=http%3A%2F%2Fwww.example.org%2Freport.php&returnurl=http%3A%2F%2Fwww.example.org%2Freturn.php

          def initialize(order, account, options = {})
            @account = account
            @fields          = {}
            @raw_html_fields = []
            @test            = options[:test]
            @options         = options
            @mappings        = {}
          end

          def credential_based_url
            @options[:notify_url] = "http://requestb.in/item_id=1231242"
            url = "#{MOLLIE_IDEAL_API_URL}?a=fetch&partnerid=#{CGI.escape(@account)}&bank_id=9999&testmode=true&amount=#{@options[:amount].cents}&description=#{CGI.escape(@options[:account_name])}&reporturl=#{CGI.escape(@options[:notify_url])}&returnurl=#{CGI.escape(@options[:return_url])}"
            Rails.logger.info url
            response = ssl_get(url)

            xml = REXML::Document.new(response)
            uri = REXML::XPath.first(xml, "//URL").text

            url = URI.parse(uri)
            @fields = CGI.parse(url.query)
            url.query = ''
            url.to_s
          end

          def form_method
            "GET"
          end

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
