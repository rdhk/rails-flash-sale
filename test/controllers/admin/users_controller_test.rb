require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get able" do
    get :able
    assert_response :success
  end

  test "should get disable" do
    get :disable
    assert_response :success
  end

end
