require 'test_helper'

class VirtualMachineDefinitionsControllerTest < ActionController::TestCase
  setup do
    @virtual_machine_definition = virtual_machine_definitions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:virtual_machine_definitions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create virtual_machine_definition" do
    assert_difference('VirtualMachineDefinition.count') do
      post :create, virtual_machine_definition: { image: @virtual_machine_definition.image, instance_type: @virtual_machine_definition.instance_type, region: @virtual_machine_definition.region, role: @virtual_machine_definition.role }
    end

    assert_redirected_to virtual_machine_definition_path(assigns(:virtual_machine_definition))
  end

  test "should show virtual_machine_definition" do
    get :show, id: @virtual_machine_definition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @virtual_machine_definition
    assert_response :success
  end

  test "should update virtual_machine_definition" do
    patch :update, id: @virtual_machine_definition, virtual_machine_definition: { image: @virtual_machine_definition.image, instance_type: @virtual_machine_definition.instance_type, region: @virtual_machine_definition.region, role: @virtual_machine_definition.role }
    assert_redirected_to virtual_machine_definition_path(assigns(:virtual_machine_definition))
  end

  test "should destroy virtual_machine_definition" do
    assert_difference('VirtualMachineDefinition.count', -1) do
      delete :destroy, id: @virtual_machine_definition
    end

    assert_redirected_to virtual_machine_definitions_path
  end
end
