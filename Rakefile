require "bundler/gem_tasks"
require "fileutils"

spec = Gem::Specification::load(Dir.glob("*.gemspec").first)
gem_file = "pkg/#{spec.name}-#{spec.version}.gem"

task build_latest: [:build] do
  FileUtils.copy(gem_file, "pkg/tagfish-latest.gem")
end

require "rspec/core/rake_task"

desc "Run the specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end
