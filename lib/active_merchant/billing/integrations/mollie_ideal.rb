require File.dirname(__FILE__) + '/mollie_ideal/return.rb'
require File.dirname(__FILE__) + '/mollie_ideal/helper.rb'
require File.dirname(__FILE__) + '/mollie_ideal/notification.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module MollieIdeal

        mattr_accessor :testmode
        self.testmode = false

        mattr_accessor :redirect_param_options
        self.redirect_param_options = [
          ['ABN AMRO', '0031'],
          ['ASN Bank', '0761'],
          ['Friesland Bank', '0091'],
          ['ING', '0721'],
          ['Knab', '0801'],
          ['Rabobank', '0021'],
          ['RegioBank', '0771'],
          ['SNS Bank', '0751'],
          ['Triodos Bank', '0511'],
          ['van Lanschot', '0161']
        ]

        MOLLIE_IDEAL_API_URL = 'https://secure.mollie.nl/xml/ideal'.freeze

        def self.mollie_api_uri(action, get_params)
          get_params = get_params.merge('testmode' => 'true') if testmode
          params = get_params.merge('a' => action).map do |key, value|
            "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
          end

          URI.parse("#{MOLLIE_IDEAL_API_URL}?#{params.join('&')}")
        end

        def self.mollie_api_request(action, get_params) 
          uri = mollie_api_uri(action, get_params)
          site = Net::HTTP.new(uri.host, uri.port)
          site.use_ssl = (uri.scheme == 'https')
          site.verify_mode = OpenSSL::SSL::VERIFY_NONE
          response = site.get(uri.to_s)
          REXML::Document.new(response.body)
        end

        def self.extract_response_parameter(xml, name)
          REXML::XPath.first(xml, "//#{name}").try(:text)
        end

        def self.notification(post, options = {})
          Notification.new(post, options)
        end

        def self.return(post, options = {})
          Return.new(post, options)
        end
      end
    end
  end
end
