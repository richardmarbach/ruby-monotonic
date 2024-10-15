# frozen_string_literal: true

require "bundler/gem_tasks"

require "rubocop/rake_task"

RuboCop::RakeTask.new

task :build do
  cd "ext/" do
    ruby "extconf.rb"
    sh "make"
  end
end

task default: %i[rubocop build]
