# encoding: utf-8
require 'spec_helper'

describe 'nmdvarnish::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'Installs the varnish package.' do
    expect(chef_run).to install_package('varnish')
  end

  it 'Configures varnish.' do
    expect(chef_run).to create_template('/etc/sysconfig/varnish').with(
      user: 'root',
      group: 'root',
      mode: 0644
    )
    expect(chef_run).to render_file('/etc/sysconfig/varnish')
      .with_content(/^# This file was generated by Chef for*.+$/)

    expect(chef_run).to render_file('/etc/sysconfig/varnish')
      .with_content(/^# Do NOT modify this file by hand!$/)

    expect(chef_run).to render_file('/etc/sysconfig/varnish')
      .with_content(/^START=yes$/)

    expect(chef_run).to render_file('/etc/sysconfig/varnish')
      .with_content(/^NFILES=131072$/)

    expect(chef_run).to render_file('/etc/sysconfig/varnish')
      .with_content(/^MEMLOCK=\d*$/)

    expect(chef_run).to render_file('/etc/sysconfig/varnish')
      .with_content(/^INSTANCE=/)

    expect(chef_run).to render_file('/etc/sysconfig/varnish')
      .with_content(/^DAEMON_OPTS="-a :6081 \\/)

    expect(chef_run).to render_file('/etc/sysconfig/varnish')
      .with_content(/^ +-T localhost:6082 \\/)

    expect(chef_run).to render_file('/etc/sysconfig/varnish')
      .with_content(%r{^ +-f /etc/varnish/default.vcl \\})

    expect(chef_run).to render_file('/etc/sysconfig/varnish')
      .with_content(/^ +-t 120 \\/)

    expect(chef_run).to render_file('/etc/sysconfig/varnish')
      .with_content(/^ +-w 50,1000,120 \\/)

    expect(chef_run).to render_file('/etc/sysconfig/varnish')
      .with_content(%r{^ +-S /etc/varnish/secret \\})

    expect(chef_run).to render_file('/etc/sysconfig/varnish')
      .with_content(/^ +-s malloc,256m"/)
  end
  it 'Configures the VCL file.' do
    expect(chef_run).to create_template('/etc/varnish/default.vcl').with(
      user: 'root',
      group: 'root',
      mode: 0644
    )
    expect(chef_run).to render_file('/etc/varnish/default.vcl')
      .with_content(/^# This file was generated by Chef for*.+$/)

    expect(chef_run).to render_file('/etc/varnish/default.vcl')
      .with_content(/^# Do NOT modify this file by hand!$/)

    expect(chef_run).to render_file('/etc/varnish/default.vcl')
      .with_content(/^backend default {/)

    expect(chef_run).to render_file('/etc/varnish/default.vcl')
      .with_content(/^backend default {/)

    expect(chef_run).to render_file('/etc/varnish/default.vcl')
      .with_content(/^ +.host = "127.0.0.1";/)

    expect(chef_run).to render_file('/etc/varnish/default.vcl')
      .with_content(/^ +.port = "80";/)

    expect(chef_run).to render_file('/etc/varnish/default.vcl')
      .with_content(/^director director1 random {/)

    expect(chef_run).to render_file('/etc/varnish/default.vcl')
      .with_content(/^director director1 random {/)

    expect(chef_run).to render_file('/etc/varnish/default.vcl')
      .with_content(/^director director2 roundrobin {/)

    expect(chef_run).to render_file('/etc/varnish/default.vcl')
      .with_content(/^acl acl1 {/)

    expect(chef_run).to render_file('/etc/varnish/default.vcl')
      .with_content(/^acl acl2 {/)

    expect(chef_run).to render_file('/etc/varnish/default.vcl')
      .with_content(/^ +."127.0.0.1"\/32;/)

    expect(chef_run).to render_file('/etc/varnish/default.vcl')
      .with_content(/^ +."127.0.1.1"\/32;/)
  end
end
