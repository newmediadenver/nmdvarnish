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

### nmdvarnish::varnish_install

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
default[:nmdvarnish][:listen_port] = '80'
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
      'host' => '192.168.33.40',
      'port' => '80'
    }
  }

default[:nmdvarnish][:director] = nil

default[:nmdvarnish][:acl] = {
  'acl1' =>
    ['"127.0.0.1"/32;', '"127.0.1.1"/32;'],
  'acl2' =>
    ['"127.0.0.3"/8;', '"127.0.0.4"/32;']
  }

default[:nmdvarnish][:vcl_recv] = '

#forward users actual IP address
remove req.http.X-Forwarded-For;
set req.http.X-Forwarded-For = client.ip;

if (client.ip ~ acl1) {
  return (lookup);
        } else {
        return (pass);
  ##error 750;
        }

if (client.ip ~ acl2) {
        return (lookup);
        } else {
        return (pass);
        ##error 750;
        }

# Do not cache these paths.
if (req.url ~ "^/status\.php$" ||
req.url ~ "^/update\.php$" ||
req.url ~ "^/admin$" ||
req.url ~ "^/admin/.*$" ||
req.url ~ "^/flag/.*$" ||
req.url ~ "^.*/ajax/.*$" ||
req.url ~ "^.*/ahah/.*$") {
return (pass);
}

# Always cache the following file types for all users. This list of extensions
# appears twice, once here and again in vcl_fetch, so make sure you edit both
# and keep them equal.
if (req.url ~
"(?i)\.(pdf|txt|doc|xls|ppt|csv|png|gif|jpeg|jpg|ico|swf|css|js)(\?.*)?$") {
unset req.http.Cookie;
}

if (req.http.Cookie) {
# Append a semicolon to the front of the cookie string.
set req.http.Cookie = ";" + req.http.Cookie;
# Remove all spaces that appear after semicolons.
set req.http.Cookie = regsuball(req.http.Cookie, "; +", ";");
#Remove has_js and Google Analytics __* cookies.
##set req.http.Cookie = regsuball(req.http.Cookie, "(^|;\s*)(_[_a-z]+|has_js)=[^;]*", "");
# Match the cookies we want to keep, adding back the space we removed
# previously. "\1" is first matching group in the regular expression match.
set req.http.Cookie = regsuball(req.http.Cookie,
";(SESS[a-z0-9]+|SSESS[a-z0-9]+|NO_CACHE)=", "; \1=");
# Remove all other cookies, identifying them by the fact that they have
# no space after the preceding semicolon.
set req.http.Cookie = regsuball(req.http.Cookie, ";[^ ][^;]*", "");
# Remove all spaces and semicolons from the beginning and end of the
# cookie string.
set req.http.Cookie = regsuball(req.http.Cookie, "^[; ]+|[; ]+$", "");

if (req.http.Cookie == "") {
# If there are no remaining cookies, remove the cookie header
# so that Varnish will cache the request.
unset req.http.Cookie;
}
else {
 # If there are any cookies left (a session or NO_CACHE cookie), do not
 # cache the page. Pass it on to the backend directly.
 return (pass);
  }
 }'
default[:nmdvarnish][:vcl_fetch] = 'set beresp.do_esi = true;
# Items returned with these status values wouldnt be cached by default,
# but by doing so we can save some Drupal overhead.
if (beresp.status == 404 || beresp.status == 301 || beresp.status == 500) {
set beresp.ttl = 10m;
}

if (req.url == "/index.html") {
       set beresp.do_esi = true; /* Do ESI processing               */
       set beresp.ttl = 2 m;    /* Sets the TTL on the HTML above  */
    }

# Dont allow static files to set cookies.
# This list of extensions appears twice, once here and again in vcl_recv, so
# make sure you edit both and keep them equal.
if (req.url ~
"(?i)\.(pdf|txt|doc|xls|ppt|csv|png|gif|jpeg|jpg|ico|swf|css|js)(\?.*)?$") {
unset beresp.http.set-cookie;
}
# Allow items to be stale if needed, in case of problems with the backend.
set beresp.grace = 6h;'
default[:nmdvarnish][:vcl_hash] = nil
default[:nmdvarnish][:vcl_hit] = nil
default[:nmdvarnish][:vcl_miss] = nil
default[:nmdvarnish][:vcl_pass] = nil
default[:nmdvarnish][:vcl_deliver] = '# Set a header to track if this was a cache hit or miss.
# Include hit count for cache hits.
if (client.ip ~ acl1) {
        set resp.http.X-inst = "inst1";
        } else {
  set resp.http.X-inst = "NA";
  }
 if (obj.hits > 0) {
 set resp.http.X-nmd-Varnish-Cache = "HIT";
 set resp.http.X-nmd-Varnish-Hits = obj.hits;
 }
 else {
 set resp.http.X-nmd-Varnish-Cache = "MISS";
 }'
default[:nmdvarnish][:vcl_vcl_error] = nil
