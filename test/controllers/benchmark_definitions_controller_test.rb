require 'test_helper'

class BenchmarkDefinitionsControllerTest < ActionController::TestCase
  setup do
    @benchmark_definition = benchmark_definitions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:benchmark_definitions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create benchmark_definition" do
    assert_difference('BenchmarkDefinition.count') do
      post :create, benchmark_definition: { name: @benchmark_definition.name }
    end

    assert_redirected_to benchmark_definition_path(assigns(:benchmark_definition))
  end

  test "should show benchmark_definition" do
    get :show, id: @benchmark_definition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @benchmark_definition
    assert_response :success
  end

  test "should update benchmark_definition" do
    patch :update, id: @benchmark_definition, benchmark_definition: { name: @benchmark_definition.name }
    assert_redirected_to benchmark_definition_path(assigns(:benchmark_definition))
  end

  test "should destroy benchmark_definition" do
    assert_difference('BenchmarkDefinition.count', -1) do
      delete :destroy, id: @benchmark_definition
    end

    assert_redirected_to benchmark_definitions_path
  end
end
