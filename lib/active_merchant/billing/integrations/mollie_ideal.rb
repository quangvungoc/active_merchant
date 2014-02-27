require File.dirname(__FILE__) + '/mollie_ideal/return.rb'
require File.dirname(__FILE__) + '/mollie_ideal/helper.rb'
require File.dirname(__FILE__) + '/mollie_ideal/notification.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module MollieIdeal

        MOLLIE_IDEAL_API_URL = 'https://secure.mollie.nl/xml/ideal'.freeze

        def self.credential_based_url(options)
          url = "#{MOLLIE_IDEAL_API_URL}?a=fetch&partnerid=#{options[:credential1]}&bank_id=9999&testmode=true&amount=#{options[:amount]}&description=test&reporturl=#{options[:notify_url]}&returnurl=#{options[:return_url]}"
          response = ssl_get(url)

          xml = REXML::Document.new(response)
          REXML::XPath.first(xml, "//URL").text
        end

        def self.notification(post)
          Notification.new(post)
        end

        def self.return(post, options = {})
          Return.new(post, options)
        end


        def self.ssl_get(url)
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
