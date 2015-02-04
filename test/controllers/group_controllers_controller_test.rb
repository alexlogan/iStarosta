require 'test_helper'

class GroupControllersControllerTest < ActionController::TestCase
  setup do
    @group_controller = group_controllers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:group_controllers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create group_controller" do
    assert_difference('GroupController.count') do
      post :create, group_controller: {  }
    end

    assert_redirected_to group_controller_path(assigns(:group_controller))
  end

  test "should show group_controller" do
    get :show, id: @group_controller
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @group_controller
    assert_response :success
  end

  test "should update group_controller" do
    patch :update, id: @group_controller, group_controller: {  }
    assert_redirected_to group_controller_path(assigns(:group_controller))
  end

  test "should destroy group_controller" do
    assert_difference('GroupController.count', -1) do
      delete :destroy, id: @group_controller
    end

    assert_redirected_to group_controllers_path
  end
end
