require 'rails_helper'
require 'rake'

describe 'foo namespace rake task' do
  it 'runs successfully' do
    Rake.application.rake_require "tasks/bar"
    Rake::Task["sitemap:create"].invoke
  end
end
