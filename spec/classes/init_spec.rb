require 'spec_helper'
describe 'oracleinstantclient' do

  context 'with defaults for all parameters' do
    it { should contain_class('oracleinstantclient') }
  end
end
