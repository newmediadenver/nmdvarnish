# encoding: utf-8
name 'nmdvarnish'
maintainer 'NewMedia! Denver'
maintainer_email 'support@newmediadenver.com'
license 'Apache 2.0'

version '1.0.0'
supports 'CentOS', '= 5.10'

desc = 'Manages varnish.'
description desc

desc = 'This is a basic cookbook to setup varnish.'

long_description desc

desc = '@TODO'
recipe 'nmdvarnish::default', desc
