require 'test_helper'

class OrderedMetricObservationsControllerTest < ActionController::TestCase
  setup do
    @ordered_metric_observation = ordered_metric_observations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ordered_metric_observations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ordered_metric_observation" do
    assert_difference('OrderedMetricObservation.count') do
      post :create, ordered_metric_observation: { metric_definition_id: @ordered_metric_observation.metric_definition_id, time: @ordered_metric_observation.time, value: @ordered_metric_observation.value, virtual_machine_instance_id: @ordered_metric_observation.virtual_machine_instance_id }
    end

    assert_redirected_to ordered_metric_observation_path(assigns(:ordered_metric_observation))
  end

  test "should show ordered_metric_observation" do
    get :show, id: @ordered_metric_observation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ordered_metric_observation
    assert_response :success
  end

  test "should update ordered_metric_observation" do
    patch :update, id: @ordered_metric_observation, ordered_metric_observation: { metric_definition_id: @ordered_metric_observation.metric_definition_id, time: @ordered_metric_observation.time, value: @ordered_metric_observation.value, virtual_machine_instance_id: @ordered_metric_observation.virtual_machine_instance_id }
    assert_redirected_to ordered_metric_observation_path(assigns(:ordered_metric_observation))
  end

  test "should destroy ordered_metric_observation" do
    assert_difference('OrderedMetricObservation.count', -1) do
      delete :destroy, id: @ordered_metric_observation
    end

    assert_redirected_to ordered_metric_observations_path
  end
end
