require 'test_helper'

class MetricObservationsControllerTest < ActionController::TestCase
  setup do
    @metric_observation = metric_observations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:metric_observations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create metric_observation" do
    assert_difference('MetricObservation.count') do
      post :create, metric_observation: { key: @metric_observation.key, value: @metric_observation.value }
    end

    assert_redirected_to metric_observation_path(assigns(:metric_observation))
  end

  test "should show metric_observation" do
    get :show, id: @metric_observation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @metric_observation
    assert_response :success
  end

  test "should update metric_observation" do
    patch :update, id: @metric_observation, metric_observation: { key: @metric_observation.key, value: @metric_observation.value }
    assert_redirected_to metric_observation_path(assigns(:metric_observation))
  end

  test "should destroy metric_observation" do
    assert_difference('MetricObservation.count', -1) do
      delete :destroy, id: @metric_observation
    end

    assert_redirected_to metric_observations_path
  end
end
