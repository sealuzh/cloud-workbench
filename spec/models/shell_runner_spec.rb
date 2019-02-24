# frozen_string_literal: true

require 'spec_helper'

describe ShellRunner do
  let(:runner_instance) { (Class.new { include ShellRunner }).new }
  describe '#shell' do
    it 'should run a shell command and return its success value' do
      expect(runner_instance.shell('true', {})).to be true
      expect(runner_instance.shell('false', {})).to be false
    end
  end
  describe '#shell_cmd' do
    it 'should compose a basic command and reset RUBYLIB' do
      expect(runner_instance.shell_cmd('mycmd', {})).to eq "RUBYLIB='' mycmd"
    end
    it 'should change into the provided directory' do
      expect(runner_instance.shell_cmd('pwd', dir: '/tmp')).to eq "cd /tmp && RUBYLIB='' pwd"
    end
    it 'should setup log redirect' do
      expect(runner_instance.shell_cmd('echo', log: '/tmp/log.txt')).to eq "RUBYLIB='' echo >>/tmp/log.txt 2>&1"
    end
  end
end
