# nexus_sync

This cookbook provides both a custom resource and a default cookbook that will sync a Nexus endpoint to a local directory. The attributes used and the custom resource are demonstrated in the default recipe:

```
nexus_sync node['nexus_sync']['directory'] do
  url node['nexus_sync']['url']
  user node['nexus_sync']['user']
  password node['nexus_sync']['password']
  action :sync
end
```
