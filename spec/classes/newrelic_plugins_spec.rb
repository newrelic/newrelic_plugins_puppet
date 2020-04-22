require 'spec_helper'

describe 'newrelic_plugins', :type => :class do
  context "osfamily = RedHat" do
    let :facts do
      {
        :osfamily        => 'RedHat',
      }
    end

    context "default usage (osfamily = RedHat)" do
      let(:title) { 'newrelic_plugins-basic' }

      it 'should compile' do
        # Nothing defined in it!
      end
    end
  end

  context "osfamily = Debian" do
    let(:facts) {{
        :osfamily        => 'Debian',
      }}
      it { should contain_class('newrelic_plugins') }
      it { should contain_class('newrelic_plugins::params') }
    end

end
