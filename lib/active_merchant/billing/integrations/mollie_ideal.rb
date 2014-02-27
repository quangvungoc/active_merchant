require File.dirname(__FILE__) + '/mollie_ideal/return.rb'
require File.dirname(__FILE__) + '/mollie_ideal/helper.rb'
require File.dirname(__FILE__) + '/mollie_ideal/notification.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module MollieIdeal

        MOLLIE_IDEAL_API_URL = 'https://secure.mollie.nl/xml/ideal'.freeze

        def self.notification(post)
          Notification.new(post)
        end

        def self.return(post, options = {})
          Return.new(post, options)
        end
      end
    end
  end
end
