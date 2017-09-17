require 'spec_helper'

describe 'psick::redis::tp' do
  on_supported_os(facterversion: '2.4').select { |k, _v| k == 'redhat-7-x86_64' || k == 'ubuntu-16.04-x86_64' }.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      default_params = {
        'ensure'             => 'present',
        'options_hash'       => {},
        'auto_repo'          => true,
        'auto_prerequisites' => true,
      }

      describe 'with default params' do
        it { is_expected.to compile }
        it { is_expected.to contain_tp__install('redis').with(default_params) }
      end

      describe 'with ensure => absent' do
        let(:params) { { 'ensure' => 'absent' } }

        it { is_expected.to contain_tp__install('redis').with(default_params.merge('ensure' => 'absent')) }
      end

      describe 'with auto_prereq => false' do
        let(:params) { { 'auto_prereq' => false } }

        it { is_expected.to contain_tp__install('redis').with(default_params.merge('auto_repo' => false, 'auto_prerequisites' => false)) }
      end

      describe 'with custom conf_hash' do
        sample_conf_hash = {
          'main' => {
            'template' => 'psick/spec/sample.erb',
          },
          'other' => {
            'source' => 'puppet:///psick/spec/sample',
          },
        }
        sample_options_hash = {
          'server' => {
            'host' => 'localhost',
            'port' => '1',
          },
          'url' => 'http://sample/',
        }
        let(:params) { { 'conf_hash' => sample_conf_hash, 'options_hash' => sample_options_hash } }

        it { is_expected.to contain_tp__install('redis').with(default_params.merge('options_hash' => sample_options_hash)) }
        it { is_expected.to contain_tp__conf('redis::main').with('ensure' => 'present', 'template' => 'psick/spec/sample.erb', 'options_hash' => sample_options_hash) }
        it { is_expected.to contain_tp__conf('redis::other').with('ensure' => 'present', 'source' => 'puppet:///psick/spec/sample') }
      end
    end
  end
end