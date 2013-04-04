$:.unshift File.dirname(__FILE__) + "../lib"

require "rubygems"
require "braspag"
require "rspec"
require "vcr"
require "webmock"

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
end

