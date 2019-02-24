# frozen_string_literal: true

require 'spec_helper'

describe ShellRunner do
  let(:runner_instance) { (Class.new { include ShellRunner }).new }
  describe 'shell command' do
    it 'should run a shell command and return its success value' do
      expect(runner_instance.shell('true', {})).to be true
      expect(runner_instance.shell('false', {})).to be false
    end
  end
end
