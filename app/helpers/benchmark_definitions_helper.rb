module BenchmarkDefinitionsHelper
  def vagrantfile_template
    template = ERB.new File.read(Rails.application.config.vagrantfile_template)
    template.result
  end
end
