require 'test_helper'

class VirtualMachineInstancesControllerTest < ActionController::TestCase
  setup do
    @virtual_machine_instance = virtual_machine_instances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:virtual_machine_instances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create virtual_machine_instance" do
    assert_difference('VirtualMachineInstance.count') do
      post :create, virtual_machine_instance: { status: @virtual_machine_instance.status }
    end

    assert_redirected_to virtual_machine_instance_path(assigns(:virtual_machine_instance))
  end

  test "should show virtual_machine_instance" do
    get :show, id: @virtual_machine_instance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @virtual_machine_instance
    assert_response :success
  end

  test "should update virtual_machine_instance" do
    patch :update, id: @virtual_machine_instance, virtual_machine_instance: { status: @virtual_machine_instance.status }
    assert_redirected_to virtual_machine_instance_path(assigns(:virtual_machine_instance))
  end

  test "should destroy virtual_machine_instance" do
    assert_difference('VirtualMachineInstance.count', -1) do
      delete :destroy, id: @virtual_machine_instance
    end

    assert_redirected_to virtual_machine_instances_path
  end
end
