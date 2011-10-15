require 'test_helper'

class TrafficPacketsControllerTest < ActionController::TestCase
  setup do
    @traffic_packet = traffic_packets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:traffic_packets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create traffic_packet" do
    assert_difference('TrafficPacket.count') do
      post :create, :traffic_packet => @traffic_packet.attributes
    end

    assert_redirected_to traffic_packet_path(assigns(:traffic_packet))
  end

  test "should show traffic_packet" do
    get :show, :id => @traffic_packet.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @traffic_packet.to_param
    assert_response :success
  end

  test "should update traffic_packet" do
    put :update, :id => @traffic_packet.to_param, :traffic_packet => @traffic_packet.attributes
    assert_redirected_to traffic_packet_path(assigns(:traffic_packet))
  end

  test "should destroy traffic_packet" do
    assert_difference('TrafficPacket.count', -1) do
      delete :destroy, :id => @traffic_packet.to_param
    end

    assert_redirected_to traffic_packets_path
  end
end
