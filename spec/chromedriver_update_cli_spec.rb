require 'spec_helper'
require 'json'

BINARY_PATH = File.expand_path './bin/chromedriver_update'

RSpec.describe ChromedriverUpdate,'CLI' do
  context 'Version' do
    it 'displays the current version to the command line' do
      result = `#{BINARY_PATH} --version`.strip
      expect(result).to eql(ChromedriverUpdate::VERSION)
    end
  end
end