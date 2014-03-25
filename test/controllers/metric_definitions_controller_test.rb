require 'test_helper'

class MetricDefinitionsControllerTest < ActionController::TestCase
  setup do
    @metric_definition = metric_definitions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:metric_definitions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create metric_definition" do
    assert_difference('MetricDefinition.count') do
      post :create, metric_definition: { name: @metric_definition.name, unit: @metric_definition.unit }
    end

    assert_redirected_to metric_definition_path(assigns(:metric_definition))
  end

  test "should show metric_definition" do
    get :show, id: @metric_definition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @metric_definition
    assert_response :success
  end

  test "should update metric_definition" do
    patch :update, id: @metric_definition, metric_definition: { name: @metric_definition.name, unit: @metric_definition.unit }
    assert_redirected_to metric_definition_path(assigns(:metric_definition))
  end

  test "should destroy metric_definition" do
    assert_difference('MetricDefinition.count', -1) do
      delete :destroy, id: @metric_definition
    end

    assert_redirected_to metric_definitions_path
  end
end
