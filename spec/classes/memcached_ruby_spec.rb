require 'spec_helper'

describe 'newrelic_plugins::memcached_ruby' do
  let(:facts) do
    {
      :osfamily      => 'RedHat',
      :nr_ruby_found => true
    }
  end

  let(:good_params) do
    {
      :install_path => '/path/to/plugin',
      :license_key  => 'NEW_RELIC_LICENSE_KEY',
      :user         => 'newrelic',
      :version      => '1.9.3',
      :agents       => []
    }
  end

  context 'Valid license key' do
    let(:params) do
      good_params.merge(:license_key => 'ABCDEFGHIJKLMnopqrstuvwxyz01234567890123')
    end

    it 'detects no error' do
      expect do
        should contain_class('newrelic_plugins::params')
      end.to_not raise_error
    end
  end

  shared_examples_for 'Invalid license key' do
    let(:params) do
      good_params.merge(:license_key => license_key)
    end

    it 'detects the invalid key' do
      expect do
        should contain_class('newrelic_plugins::params')
      end.to raise_error(Puppet::Error, /^The provided New Relic License Key is invalid/)
    end
  end

  context 'key is too short' do
    let(:license_key) { '1' }
    it_behaves_like 'Invalid license key'
  end

  context 'key is too long' do
    let(:license_key) { '01234567890123456789012345678901234567891' }
    it_behaves_like 'Invalid license key'
  end

  context 'key has invalid characters' do
    let(:license_key) { '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$' }
    it_behaves_like 'Invalid license key'
  end

end
