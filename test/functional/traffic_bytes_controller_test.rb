require 'test_helper'

class TrafficBytesControllerTest < ActionController::TestCase
  setup do
    @traffic_byte = traffic_bytes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:traffic_bytes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create traffic_byte" do
    assert_difference('TrafficByte.count') do
      post :create, :traffic_byte => @traffic_byte.attributes
    end

    assert_redirected_to traffic_byte_path(assigns(:traffic_byte))
  end

  test "should show traffic_byte" do
    get :show, :id => @traffic_byte.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @traffic_byte.to_param
    assert_response :success
  end

  test "should update traffic_byte" do
    put :update, :id => @traffic_byte.to_param, :traffic_byte => @traffic_byte.attributes
    assert_redirected_to traffic_byte_path(assigns(:traffic_byte))
  end

  test "should destroy traffic_byte" do
    assert_difference('TrafficByte.count', -1) do
      delete :destroy, :id => @traffic_byte.to_param
    end

    assert_redirected_to traffic_bytes_path
  end
end
