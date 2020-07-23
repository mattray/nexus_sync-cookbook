#
# Cookbook:: nexus_sync
# Recipe:: default
#

require 'net/http'
require 'openssl'
require 'uri'
require 'json'

directory node['nexus_sync']['directory'] do
  recursive true
end

# get the list of artifacts
uri = URI.parse(node['nexus_sync']['url'])
request = Net::HTTP::Get.new(uri)

# request["Api-Token"] = node['nexus_sync']['token']
request.basic_auth(node['nexus_sync']['user'], node['nexus_sync']['password'])

req_options = {
               use_ssl: uri.scheme == 'https',
               verify_mode: OpenSSL::SSL::VERIFY_NONE,
              }

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

downloads = JSON.parse(response.body)

# iterate over response, downloading anything that doesn't already exist
downloads['items'].each do |url|
  filename = url['path'].split('/')[1]
  remote_file filename do
    source url['downloadUrl']
    remote_user node['nexus_sync']['user']
    remote_password node['nexus_sync']['password']
    # checksum url['checksum']['sha256']
  end
end
