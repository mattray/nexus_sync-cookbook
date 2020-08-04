#
# Cookbook:: nexus_sync
# Recipe:: default
#

nexus_sync node['nexus_sync']['directory'] do
  url node['nexus_sync']['url']
  user node['nexus_sync']['user']
  password node['nexus_sync']['password']
  action :sync
end
