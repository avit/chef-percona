#
# Cookbook Name:: percona
# Recipe:: package_repo
#

case node['platform_family']

when "debian"
  include_recipe "apt"

  # Pin this repo as to avoid upgrade conflicts with distribution repos.
  apt_preference "00percona" do
    glob "*"
    pin "release o=Percona Development Team"
    pin_priority "1001"
  end

  repo_name = case node['lsb']['codename']
              when 'trusty' then 'saucy'
              else node['lsb']['codename']
              end

  apt_repository "percona" do
    uri node['percona']['apt_uri']
    distribution repo_name
    components [ "main" ]
    keyserver node['percona']['apt_keyserver']
    key node['percona']['apt_key']
    action :add
  end

when "rhel"
  include_recipe "yum"

  arch = node['kernel']['machine'] == "x86_64" ? "x86_64" : "i386"
  pversion = node['platform_version'].to_i
  yum_repository 'percona' do
    description 'Percona Packages'
    baseurl "http://repo.percona.com/centos/#{pversion}/os/#{arch}/"
    gpgkey 'http://www.percona.com/downloads/RPM-GPG-KEY-percona'
    action :create
  end
end
