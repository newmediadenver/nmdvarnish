# encoding: utf-8
#
# Cookbook Name:: varnish
# Attributes:: default
#
# Author:: David Arnold
# Copyright:: 2014, NewMedia Denver
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

### nmdvarnish::default

# Varnish configuration file path.
default['nmdvarnish']['varnishconf']['path'] = '/etc/sysconfig/varnish'

# Set varnish configuration options to enable a default install.
default[:nmdvarnish][:start] = 'yes'
default[:nmdvarnish][:nfiles] = '131072'
default[:nmdvarnish][:memlock] = '82000'
default[:nmdvarnish][:instance] = '$(uname -n)'
default[:nmdvarnish]['listen.address'] = 'localhost'
default[:nmdvarnish]['listen.port'] = '6081'
default[:nmdvarnish]['management.hostname'] = 'localhost'
default[:nmdvarnish]['management.port'] = '6082'
default[:nmdvarnish]['vcl.file'] = '/etc/varnish/default.vcl'
default[:nmdvarnish]['default.ttl'] =  '120'
default[:nmdvarnish]['threads.min'] =  '50'
default[:nmdvarnish]['threads.max'] =  '1000'
default[:nmdvarnish]['threads.timeout'] =  '120'
default[:nmdvarnish]['secretfile'] = '/etc/varnish/secret'
default[:nmdvarnish]['storage.type'] = 'malloc'
default[:nmdvarnish]['storage.options'] = '256m'

# Specify the path to the varnish VCL file.

default[:nmdvarnish][:vclfile] = '/etc/varnish/default.vcl'

# Varnish VCL configuration options.

default[:nmdvarnish]['backend.host'] = '127.0.0.1'
default[:nmdvarnish]['backend.port'] = '80'
default[:nmdvarnish]['acl1.name'] = 'default'
default[:nmdvarnish]['acl1.addresses'] = ['"127.0.0.1"/32', '"127.0.1.1"/32']
