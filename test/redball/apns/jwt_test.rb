require "test_helper"

class ApnsJwtTest < Minitest::Test
  def setup
    @device_token = ENV.fetch("APN_TEST_DEVICE_TOKEN")
    @apn_topic    = ENV.fetch("APN_TEST_TOPIC")

    @client = Redball::Apns.jwt(
      environment: :production,
      cert_path:   ENV.fetch("APN_TEST_CERTIFICATE_PATH"),
      team_id:     ENV.fetch("APN_TEST_TEAM_ID"),
      key_id:      ENV.fetch("APN_TEST_KEY_ID"),
    )
  end

  def test_client_can_send_push_notification
    body = {
      aps: {
        alert: {
          title: "Build for the apns-jwt gem was 🍏",
          body: "The test for #{RUBY_DESCRIPTION} has passed."
        }
      },
      badge: 1,
      sound: "bingbong.aiff"
    }

    response = @client.push(@device_token, body, headers: { 'apns-topic' => @apn_topic })

    assert_equal 200, response.status
  end

  def test_client_raises_exeption_on_failure
    error = assert_raises Redball::Apns::BadRequest do
              @client.push('invalid-token', {}, headers: { 'apns-topic' => @apn_topic })
            end

    assert_equal 400, error.response.status
    assert_equal "BadDeviceToken", error.response.json[:reason]
  end
end
