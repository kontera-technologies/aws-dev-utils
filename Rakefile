require 'rake/testtask'

task default: :test

Rake::TestTask.new do |t|
  t.warning = false
  t.test_files = FileList['tests/unit/*_test.rb']
end
