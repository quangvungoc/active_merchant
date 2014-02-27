require 'test_helper'

class MollieIdealNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @mollie_ideal = MollieIdeal::Notification.new(http_raw_data)
  end

  def test_accessors
    assert @mollie_ideal.complete?
    assert_equal "", @mollie_ideal.status
    assert_equal "", @mollie_ideal.transaction_id
    assert_equal "", @mollie_ideal.item_id
    assert_equal "", @mollie_ideal.gross
    assert_equal "", @mollie_ideal.currency
    assert_equal "", @mollie_ideal.received_at
    assert @mollie_ideal.test?
  end

  def test_compositions
    assert_equal Money.new(3166, 'USD'), @mollie_ideal.amount
  end

  # Replace with real successful acknowledgement code
  def test_acknowledgement

  end

  def test_send_acknowledgement
  end

  def test_respond_to_acknowledge
    assert @mollie_ideal.respond_to?(:acknowledge)
  end

  private
  def http_raw_data
    ""
  end
end
