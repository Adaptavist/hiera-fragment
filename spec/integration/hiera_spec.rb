# Copyright 2015 Adaptavist.com Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'hiera'
require 'rspec'

RSpec.describe Hiera do
  describe '#fragment', :standard => true do
    context 'with default config' do
      it 'has replaced single value' do
        hiera = Hiera.new(:config => 'test/hiera.yaml')
        value = hiera.lookup('str', nil, [])
        expect(value).to eq('a replaced value')
      end
      it 'has replaced a whole hash' do
        hiera = Hiera.new(:config => 'test/hiera.yaml')
        value = hiera.lookup('test', nil, [])
        expect(value).to eq({'foo' => 'bar', 'baz' => 'asd'})
      end
      it 'has replaced a partial hash' do
        hiera = Hiera.new(:config => 'test/hiera.yaml')
        value = hiera.lookup('partial', nil, [])
        expect(value['key']).to eq('a replaced value')
      end
      it 'has replaced a nested value' do
        hiera = Hiera.new(:config => 'test/hiera.yaml')
        value = hiera.lookup('nested', nil, [])
        expect(value['level1']['level2']).to eq('a replaced value')
      end
      it 'hash lookup still works' do
        hiera = Hiera.new(:config => 'test/hiera.yaml')
        value = hiera.lookup('hash', nil, [], nil, :hash)
        expect(value['key']).to eq('value')
      end

      it 'array lookup still works' do
        hiera = Hiera.new(:config => 'test/hiera.yaml')
        value = hiera.lookup('array', nil, [], nil, :array)
        expect(value).to eq(['one', 'two'])
      end
    end
  end
end
