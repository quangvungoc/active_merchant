require 'test_helper'

class MollieIdealModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def test_notification_method
    assert_instance_of MollieIdeal::Notification, MollieIdeal.notification('name=cody')
  end
end
