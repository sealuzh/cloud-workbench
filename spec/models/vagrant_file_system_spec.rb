require 'rails_helper'

describe VagrantFileSystem do
  let(:benchmark_definition) { build(:benchmark_definition, id: 7, name: 'bm-with_symbol%and\\no.dot') }
  let(:benchmark_execution) { build(:benchmark_execution, benchmark_definition: benchmark_definition, id: 8) }
  let(:vagrant_fs) { build(:vagrant_file_system, benchmark_definition: benchmark_definition,
                                                 benchmark_execution: benchmark_execution) }
  let(:base_path) { Rails.application.config.benchmark_executions }

  describe 'base_path' do
    it 'return the benchmark executions directory' do
      expect(vagrant_fs.base_path).to eq "#{Rails.root}/storage/test/benchmark_executions"
    end
  end

  describe 'benchmark_definition_dir_name' do
    it 'returns the sanitized benchmark definition directory name' do
      expect(vagrant_fs.benchmark_definition_dir_name).to eq('007-bm_with_symbol_and_no_dot')
    end
  end

  describe 'benchmark_execution_dir_name' do
    it 'returns the right adjusted benchmark_execution id' do
      expect(vagrant_fs.benchmark_execution_dir_name).to eq '0008'
    end
  end

  describe 'benchmark_execution_dir' do
    it 'returns the correct path to the benchmark execution directory' do
      expect(vagrant_fs.benchmark_execution_dir).to eq("#{base_path}/007-bm_with_symbol_and_no_dot/0008")
    end
  end

  describe 'Vagrantfile path' do
    it 'returns the path to the Vagrantfile' do
      expect(vagrant_fs.vagrantfile_path).to eq("#{vagrant_fs.benchmark_execution_dir}/vagrant/Vagrantfile")
    end
  end

  describe 'prepare_vagrantfile_for_driver' do
    before { vagrant_fs.prepare_vagrantfile_for_driver }

    describe 'create directory structure' do
      it 'should create a log directory' do
        expect(File).to exist(vagrant_fs.log_dir)
      end
    end

    describe 'write Vagrantfile to file system' do
      it 'should create the Vagrantfile at the vagrantfile_path' do
        expect(File).to exist(vagrant_fs.vagrantfile_path)
      end
      it 'should include the content of the Vagranfile in the db' do
        expect(File.read(vagrant_fs.vagrantfile_path)).to include(benchmark_definition.vagrantfile)
      end
    end
  end
end