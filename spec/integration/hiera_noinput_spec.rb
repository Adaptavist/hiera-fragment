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
