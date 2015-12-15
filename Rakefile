require "bundler/gem_tasks"
require "fileutils"

spec = Gem::Specification::load(Dir.glob("*.gemspec").first)
gem_file = "pkg/#{spec.name}-#{spec.version}.gem"
docker_uri = "cowbell/#{spec.name}"
tag = "#{spec.version}"

desc "build docker image locally"
task build_docker_image: [:build] do
  FileUtils.copy(gem_file, "pkg/tagfish-latest.gem")
  sh "docker build -t #{docker_uri}:#{tag} ."
  sh "docker tag -f #{docker_uri}:#{tag} #{docker_uri}:latest"
  puts "Built image #{docker_uri}"
end

desc "Release docker image"
task release_docker_image: [:build_docker_image] do
  sh "docker push #{docker_uri}:#{tag}"
  sh "docker push #{docker_uri}:latest"
end

desc "Check for git sync"
task :no_local_changes do
  sh "git pull"
  sh "git diff HEAD --exit-code"
end

desc "Tag version into git repo"
task git_tag: [:no_local_changes] do
  puts "blah"
  sh "git tag #{tag}"
  sh "git push origin --tags"
end

desc "Release gem and docker image"
task release_all: [:git_tag, :release, :release_docker_image] do
  puts "Released all"
end
