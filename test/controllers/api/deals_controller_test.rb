require 'test_helper'

class Api::DealsControllerTest < ActionController::TestCase
  test "should get live" do
    get :live
    assert_response :success
  end

  test "should get past" do
    get :past
    assert_response :success
  end

end
