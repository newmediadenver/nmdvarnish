[![Stories in Ready](https://badge.waffle.io/newmediadenver/nmdvarnish.png?label=ready&title=Ready)](https://waffle.io/newmediadenver/nmdvarnish)
[![Build Status](https://travis-ci.org/newmediadenver/nmdvarnish.svg?branch=master)](https://travis-ci.org/newmediadenver/nmdvarnish) [![Coverage Status](https://coveralls.io/repos/newmediadenver/nmdvarnish/badge.png?branch=master)](https://coveralls.io/r/newmediadenver/nmdvarnish?branch=master) [![Dependency Status](https://gemnasium.com/newmediadenver/nmdvarnish.svg)](https://gemnasium.com/newmediadenver/nmdvarnish)

NewMedia! Denver's nmdvarnish cookbook
======================================

nmdvarnish (1.0.0) Manages varnish.

This is a basic cookbook to setup varnish.

Requirements
------------

### Platforms

`centos = 5`

### Dependencies


Attributes
----------

### nmdvarnish::default

### nmdvarnish::varnish_install installs version 3.0.5

    # Varnish configuration file path.
    default[:nmdvarnish][:varnishconf][:path] = '/etc/sysconfig/varnish'


    # Specify the path to the varnish VCL file.
    default[:nmdvarnish][:vclfile] = '/etc/varnish/default.vcl'

    # Set varnish configuration options to enable a default install.
    default[:nmdvarnish][:start] = 'yes'
    default[:nmdvarnish][:nfiles] = '131072'
    default[:nmdvarnish][:memlock] = '82000'
    default[:nmdvarnish][:instance] = '$(uname -n)'
    default[:nmdvarnish][:listen_address] = ''
    default[:nmdvarnish][:listen_port] = '6081'
    default[:nmdvarnish][:management_hostname] = 'localhost'
    default[:nmdvarnish][:management_port] = '6082'
    default[:nmdvarnish][:vcl_file] = '/etc/varnish/default.vcl'
    default[:nmdvarnish][:default_ttl] =  '120'
    default[:nmdvarnish][:threads_min] =  '50'
    default[:nmdvarnish][:threads_max] =  '1000'
    default[:nmdvarnish][:threads_timeout] =  '120'
    default[:nmdvarnish][:secretfile] = '/etc/varnish/secret'
    default[:nmdvarnish][:storage_type] = 'malloc'
    default[:nmdvarnish][:storage_options] = '256m'

### nmdvarnish::varnish_configure

    # Varnish VCL configuration options.

    default[:nmdvarnish][:backend] =
      {
        'default' => {
          'host' => '127.0.0.1',
          'port' => '80'
        },
        'default2' => {
          'host' => '127.0.1.1',
          'port' => '81'
        }
      }

    default[:nmdvarnish][:director] =
      {
        'director1' => {
          'random' => [
            [
              ' { .backend = default; .weight = 1; }',
              ' { .backend = default2; .weight = 2; }'
            ]
          ]
        },
        'director2' => {
          'roundrobin' => [
            [
              '{ .backend = default2; }',
              '{ .backend = ( .host = "localhost"; .port = "82"; ) }'
            ]
          ]
        }
      }

    default[:nmdvarnish][:acl] = {
      'acl1' =>
        ['"127.0.0.1"/32;', '"127.0.1.1"/32;'],
      'acl2' =>
        ['"127.0.0.3"/8;', '"127.0.0.4"/32;']
      }

    # Varnish VCL subroutines defined as an attribute.

    default[:nmdvarnish][:vcl_recv] = ''
    default[:nmdvarnish][:vcl_fetch] = ''
    default[:nmdvarnish][:vcl_hash] = ''
    default[:nmdvarnish][:vcl_hit] = ''
    default[:nmdvarnish][:vcl_miss] = ''
    default[:nmdvarnish][:vcl_pass] = ''
    default[:nmdvarnish][:vcl_deliver] = ''
    default[:nmdvarnish][:vcl_vcl_error] = ''

Recipes
-------

### nmdvarnish::default
    Installs the varnish package.
    Configures varnish.
    Configures the VCL file.


Testing and Utility
-------

    rake foodcritic                  # Lint Chef cookbooks
    rake integration                 # Alias for kitchen:all
    rake kitchen:all                 # Run all test instances
    rake kitchen:default-centos-510  # Run default-centos-510 test instance
    rake readme                      # Generate the Readme.md file
    rake rubocop                     # Run RuboCop style and lint checks
    rake spec                        # Run ChefSpec examples
    rake test                        # Run all tests


License and Author
------------------

Author:: David Arnold

Copyright:: 2014, NewMedia Denver

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Contributing
------------

We welcome contributed improvements and bug fixes via the usual workflow:

1. Fork this repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request
