require "test_helper"

class JogosControllerTest < ActionDispatch::IntegrationTest
  test "should get card" do
    get jogos_card_url
    assert_response :success
  end
end
