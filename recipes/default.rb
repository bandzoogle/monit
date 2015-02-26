package "monit"

cookbook_file "/etc/default/monit" do
  source "monit.default"
  owner "root"
  group "root"
  mode 0644
  only_if { platform?("ubuntu") || platform?("debian") }
end


directory node["monit"]["config_dir"] do
  owner  'root'
  group 'root'
  mode 0755
  action :create
  recursive true
end

template node["monit"]["config_file"] do
  owner "root"
  group "root"
  mode 0700
  source 'monitrc.erb'
  notifies :restart, "service[monit]", :delayed
end

service "monit" do
  action [:enable, :start]
  supports [:start, :restart, :stop]
end
