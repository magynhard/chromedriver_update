require 'spec_helper'

RSpec.describe ChromedriverUpdate do
  it 'has a version number' do
    expect(ChromedriverUpdate::VERSION).not_to be nil
  end
end