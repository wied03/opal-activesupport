require 'bundler/gem_tasks'

desc 'Runs tests'
task :default do
  require 'opal-activesupport'
  require 'opal/minitest'
  test_paths = %w(rails/activesupport/test test)
  paths = Opal.paths + test_paths
  test_stubs = [
      # Threads/file I/O
      'abstract_unit',
      # File I/O
      'active_support/testing/isolation'
  ]
  stubs = Opal::Processor.stubbed_files + test_stubs
  flat_paths = paths.map {|p| "-I#{p}"}.join ' '
  flat_stubs = stubs.map {|s| "-s#{s}"}.join ' '
  requires = %w{opal-activesupport opal_activesup_helper}
  flat_requires = requires.map {|r| "-r#{r}"}.join ' '
  opal_command_line = "#{flat_paths} #{flat_stubs} #{flat_requires} rails/activesupport/test/number_helper_test.rb"
  begin
    sh "opal -R node #{opal_command_line}"
  rescue
    sh "opal -c #{opal_command_line} > debug.js"
    raise
  end
end
