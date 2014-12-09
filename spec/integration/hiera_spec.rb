require 'hiera'
require 'rspec'

RSpec.describe Hiera do
  describe '#fragment' do
    context 'with default config' do
      hiera = Hiera.new(:config => 'test/hiera.yaml')
      it 'has replaced single value' do
        value = hiera.lookup('str', nil, [])
        expect(value).to eq('a replaced value')
      end
      it 'has replaced a whole hash' do
        value = hiera.lookup('test', nil, [])
        expect(value).to eq({'foo' => 'bar', 'baz' => 'asd'})
      end
      it 'has replaced a partial hash' do
        value = hiera.lookup('partial', nil, [])
        expect(value['key']).to eq('a replaced value')
      end
    end
  end
end
