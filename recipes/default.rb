package "monit"

cookbook_file "/etc/default/monit" do
  source "monit.default"
  owner "root"
  group "root"
  mode 0644
  only_if { platform?("ubuntu") || platform?("debian") }
end


directory "/etc/monit/conf.d/" do
  owner  'root'
  group 'root'
  mode 0755
  action :create
  recursive true
end

if platform?("ubuntu")
  config_dest = "/etc/monit/monitrc"
else
  config_dest = "/etc/monit.conf"
end

template config_dest do
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
