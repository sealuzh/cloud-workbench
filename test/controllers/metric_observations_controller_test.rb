require 'test_helper'

class MetricObservationsControllerTest < ActionController::TestCase
  setup do
    @nominal_metric_observation = metric_observations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nominal_metric_observations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create metric_observation" do
    assert_difference('MetricObservation.count') do
      post :create, nominal_metric_observation: { key: @nominal_metric_observation.key, value: @nominal_metric_observation.value }
    end

    assert_redirected_to metric_observation_path(assigns(:nominal_metric_observation))
  end

  test "should show metric_observation" do
    get :show, id: @nominal_metric_observation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nominal_metric_observation
    assert_response :success
  end

  test "should update metric_observation" do
    patch :update, id: @nominal_metric_observation, nominal_metric_observation: { key: @nominal_metric_observation.key, value: @nominal_metric_observation.value }
    assert_redirected_to metric_observation_path(assigns(:nominal_metric_observation))
  end

  test "should destroy metric_observation" do
    assert_difference('MetricObservation.count', -1) do
      delete :destroy, id: @nominal_metric_observation
    end

    assert_redirected_to metric_observations_path
  end
end
