require 'test_helper'

class BenchmarkExecutionsControllerTest < ActionController::TestCase
  setup do
    @benchmark_execution = benchmark_executions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:benchmark_executions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create benchmark_execution" do
    assert_difference('BenchmarkExecution.count') do
      post :create, benchmark_execution: { end_time: @benchmark_execution.end_time, start_time: @benchmark_execution.start_time, status: @benchmark_execution.status }
    end

    assert_redirected_to benchmark_execution_path(assigns(:benchmark_execution))
  end

  test "should show benchmark_execution" do
    get :show, id: @benchmark_execution
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @benchmark_execution
    assert_response :success
  end

  test "should update benchmark_execution" do
    patch :update, id: @benchmark_execution, benchmark_execution: { end_time: @benchmark_execution.end_time, start_time: @benchmark_execution.start_time, status: @benchmark_execution.status }
    assert_redirected_to benchmark_execution_path(assigns(:benchmark_execution))
  end

  test "should destroy benchmark_execution" do
    assert_difference('BenchmarkExecution.count', -1) do
      delete :destroy, id: @benchmark_execution
    end

    assert_redirected_to benchmark_executions_path
  end
end
