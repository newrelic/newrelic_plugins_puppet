require 'spec_helper'

describe 'newrelic_plugins', :type => :class do
  context "osfamily = RedHat" do
    let :facts do
      {
        :osfamily        => 'RedHat'
      }
    end

    context "default usage (osfamily = RedHat)" do
      let(:title) { 'newrelic_plugins-basic' }

      it { should compile.with_all_deps }
    end
  end
end
