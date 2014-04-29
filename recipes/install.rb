# encoding: utf-8
#
# Cookbook Name:: nmdvarnish
# Recipe:: default
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
#

if platform_family?('rhel')
  major_version = node[:platform_version].split('.')
  case major_version[0]
  when '5'
    execute 'add-varnish3-centos5-rpm' do
      # rubocop:disable LineLength, StringLiterals
      command '/bin/rpm --nosignature -i http://repo.varnish-cache.org/redhat/varnish-3.0/el5/noarch/varnish-release/varnish-release-3.0-1.el5.centos.noarch.rpm'
      # rubocop:enable LineLength, StringLiterals
      not_if { ::File.exist?('/usr/sbin/varnishd') }
    end
  when '6'
    execute 'add-varnish3-centos6-rpm' do
      # rubocop:disable LineLength, StringLiterals
      command '/bin/rpm --nosignature -i http://repo.varnish-cache.org/redhat/varnish-3.0/el5/noarch/varnish-release/varnish-release-3.0-1.el5.centos.noarch.rpm'
      # rubocop:enable LineLength, StringLiterals
      not_if { ::File.exist?('/usr/sbin/varnishd') }
    end
  end
end

package 'varnish' do
  action :install
end
