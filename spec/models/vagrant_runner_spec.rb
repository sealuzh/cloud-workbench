# frozen_string_literal: true

require 'spec_helper'

describe VagrantRunner do
  let(:vagrant_dir) { '/tmp/vagrant' }
  let(:vagrant_runner) { FactoryBot.build(:vagrant_runner, vagrant_dir: vagrant_dir) }

  describe '#vagrant_dir' do
    it 'should return the vagrant directory' do
      expect(vagrant_runner.vagrant_dir).to eq vagrant_dir
    end
  end

  describe '#vagrant_dir' do
    it 'should return the vagrant directory' do
      expect(vagrant_runner.ssh_shell_cmd('start_script', '/tmp', '/tmp/log.txt')).to eq "vagrant ssh -- \"cd '/tmp';
    nohup './start_script' >/dev/null 2>>'/tmp/log.txt' </dev/null &\""
    end
  end
end
