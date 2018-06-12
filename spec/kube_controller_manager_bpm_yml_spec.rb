# frozen_string_literal: true

require 'rspec'
require 'spec_helper'
require 'yaml'

describe 'kube_controller_manager' do
  it 'has no http proxy when no proxy is defined' do
    rendered_kube_controller_manager_bpm_yml = compiled_template(
      'kube-controller-manager',
      'config/bpm.yml',
      {}
    )

    bpm_yml = YAML.safe_load(rendered_kube_controller_manager_bpm_yml)
    expect(bpm_yml['processes'][1]['env']).to be_nil
  end

  it 'sets http_proxy when an http proxy is defined' do
    rendered_kube_controller_manager_bpm_yml = compiled_template(
      'kube-controller-manager',
      'config/bpm.yml',
      'http_proxy' => 'proxy.example.com:8090'
    )

    bpm_yml = YAML.safe_load(rendered_kube_controller_manager_bpm_yml)
    expect(bpm_yml['processes'][1]['env']['http_proxy']).to eq('proxy.example.com:8090')
    expect(bpm_yml['processes'][1]['env']['HTTP_PROXY']).to eq('proxy.example.com:8090')
  end

  it 'sets https_proxy when an https proxy is defined' do
    rendered_kube_controller_manager_bpm_yml = compiled_template(
      'kube-controller-manager',
      'config/bpm.yml',
      'https_proxy' => 'proxy.example.com:8100'
    )

    bpm_yml = YAML.safe_load(rendered_kube_controller_manager_bpm_yml)
    expect(bpm_yml['processes'][1]['env']['https_proxy']).to eq('proxy.example.com:8100')
    expect(bpm_yml['processes'][1]['env']['HTTPS_PROXY']).to eq('proxy.example.com:8100')
  end

  it 'sets no_proxy when no proxy property is set' do
    rendered_kube_controller_manager_bpm_yml = compiled_template(
      'kube-controller-manager',
      'config/bpm.yml',
      'no_proxy' => 'noproxy.example.com,noproxy.example.net'
    )

    bpm_yml = YAML.safe_load(rendered_kube_controller_manager_bpm_yml)
    expect(bpm_yml['processes'][1]['env']['no_proxy']).to eq('noproxy.example.com,noproxy.example.net')
    expect(bpm_yml['processes'][1]['env']['NO_PROXY']).to eq('noproxy.example.com,noproxy.example.net')
  end
end
