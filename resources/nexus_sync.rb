resource_name :nexus_sync
provides :nexus_sync

property :directory, String, name_property: true
property :url, String, required: true
property :user, String, required: true
property :password, String, required: true

action :sync do
  sync_dir = new_resource.directory
  sync_url = new_resource.url
  sync_user = new_resource.user
  sync_password = new_resource.password

  require 'json'

  directory sync_dir do
    recursive true
  end

  # use mixlib-shellout to call curl to get the list of artifacts
  command = "curl -k --user #{sync_user}:#{sync_password} -X GET #{sync_url}"
  cmd = shell_out(command)
  artifacts = JSON.parse(cmd.stdout)

  # iterate over response, downloading anything that doesn't already exist
  artifacts['items'].each do |url|
    filename = url['path'].split('/')[1]
    remote_file "#{sync_dir}/#{filename}" do
      source "https://#{sync_user}:#{sync_password}@#{url['downloadUrl'].sub('https://', '')}"
      checksum url['checksum']['sha256']
    end
  end
end
