$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'bundler/setup'
Bundler.setup :test

require 'test/unit'
require 'webmock/test_unit'
include WebMock::API

require 'runkeeper-activities'

class Test::Unit::TestCase
  def data_dir
    File.join(File.dirname(__FILE__), 'data')
  end

  def stub_get_profile
    stub_request(:get, /runkeeper.com\/user\/.+\/activity$/).to_return(File.new(File.join(data_dir, 'profile.txt')))
  end

  def stub_get_non_existing_profile
    stub_request(:get, /runkeeper.com\/user\/non-existing\/activity$/).to_return(File.new(File.join(data_dir, 'non_existing_profile.txt')))
  end

  def stub_get_activity
    stub_request(:get, /runkeeper.com\/ajax\/.+/).to_return(File.new(File.join(data_dir, 'activity.txt')))
  end
end
