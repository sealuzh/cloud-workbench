require 'rails_helper'

describe VirtualMachineInstancesController do
  let(:vm) { create(:virtual_machine_instance) }
  let(:execution) { vm.benchmark_execution }

  describe 'complete benchmark' do

    context 'with success' do
      let(:success_message) { 'Benchmark completed message' }

      describe 'and continue' do
        before do
          complete_benchmark(vm, continue: true)
        end

        it 'should create a finished benchmark event' do
          expect(execution.events).to contain_event :finished_running
        end

        it 'should create a started postprocessing event' do
          expect(execution.events).to contain_event :started_postprocessing
        end
      end

      describe 'and wait' do
        before do
          complete_benchmark(vm, continue: false)
        end

        it 'should create a finished benchmark event' do
          expect(execution.events).to contain_event :finished_running
        end

        it 'should create an asynchronous job' do
          expect do
            post_notify(vm, complete_benchmark_virtual_machine_instances_path, '', continue: false)
          end.to change(Delayed::Job, :count).by(1)
        end
      end
    end

    context 'with failure' do
      let(:failed_message) { 'Benchmark failed message' }

      before do
        complete_benchmark(vm, message: failed_message, success: false)
      end

      it 'should create a failed benchmark event' do
        expect(execution.events).to contain_event :failed_on_running
      end

      it 'should create an asynchronous job' do
        expect do
          post_notify(vm, complete_benchmark_virtual_machine_instances_path, '', success: false)
        end.to change(Delayed::Job, :count).by(1)
      end
    end

    def complete_benchmark(vm, opts = {})
      message = opts[:message] || success_message
      post_notify(vm, complete_benchmark_virtual_machine_instances_path, message, opts)
    end
  end

  describe 'complete postprocessing' do

    context 'with success' do
      let(:success_message) { 'Postprocessing completed message' }
      before do
        post_notify(vm, complete_postprocessing_virtual_machine_instances_path, 'Postprocessing completed message')
      end

      it 'should create a finished postprocessing event' do
        expect(execution.events).to contain_event :finished_postprocessing
      end

      it 'should create an asynchronous job' do
        expect do
          post_notify(vm, complete_postprocessing_virtual_machine_instances_path, '')
        end.to change(Delayed::Job, :count).by(1)
      end
    end

    context 'with failure' do
      let(:failed_message) { 'Postprocessing failed message' }
      before do
        complete_postprocessing(vm, message: failed_message, success: false)
      end

      it 'should create a failed postprocessing event' do
        expect(execution.events).to contain_event :failed_on_postprocessing
      end
    end

    def complete_postprocessing(vm, opts = {})
      message = opts[:message] || success_message
      post_notify(vm, complete_postprocessing_virtual_machine_instances_path, message, opts)
    end
  end

  def post_notify(vm, path, message = '', opts = {})
    post(path, params:
        {
            provider_name: vm.provider_name,
            provider_instance_id: vm.provider_instance_id,
            success: true,
            message: message,
        }.merge(opts))
  end
end
