require 'test_helper'

class RemoteMollieIdealIntegrationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def test_credential_based_url
    options = {
      credential1: '1487031',
      amount: 123,
      notify_url: 'http://shop1.myshopify.io/notify',
      return_url: 'http://shop1.myshopify.io/return',
    }
    url = MollieIdeal.credential_based_url(options)
    assert URI.parse(url)
  end
end
