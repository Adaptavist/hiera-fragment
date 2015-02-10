require 'hiera'
require 'rspec'

RSpec.describe Hiera do
  describe '#no-data-dir', :standalone => true do
    context 'with no data dir' do
      it 'no replacement made' do
        hiera = Hiera.new(:config => 'test/hiera-nodatadir.yaml')
        value = hiera.lookup('str', nil, [])
        expect(value).to eq('one')
      end
    end
  end
end
