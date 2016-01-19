require 'puppet'
require 'puppetclassify'
require 'yaml'

class Mkgroups
  def initialize
    Puppet.initialize_settings(['--confdir','/etc/puppetlabs/puppet'])
    auth_info = {
      "ca_certificate_path" => Puppet.settings[:localcacert],
      "certificate_path"    => Puppet.settings[:hostcert],
      "private_key_path"    => Puppet.settings[:hostprivkey]
    }

    nc_config = YAML.load_file(File.join(Puppet.settings[:confdir],'classifier.yaml'))
    classifier_url = "https://#{nc_config['server']}:#{nc_config['port']}/classifier-api"
    @puppetclassify = PuppetClassify.new(classifier_url,auth_info)

    @all_nodes = @puppetclassify.groups.get_group_id 'All Nodes'
  end

  def create_group name,parent='All Nodes',classes={},rules=[],children={}

    if parent == 'All Nodes'
      parent_id = @all_nodes
    else
      parent_id = @puppetclassify.groups.get_group_id parent
    end

    group_info = {
      'name'        => name,
      'description' => "Auto generated group #{name}",
      'parent'      => parent_id,
      'rule'        => rules,
      'classes'     => classes
    }

    @puppetclassify.groups.create_group group_info

    if children != {}
      # recursively create child groups
      children.each do |child_name,child_info|
        create_group child_name,name,child_info['classes'],child_info['rules'],child_info['children']
      end
    end
  end

  def create_groups_from_file file='groups.yaml'
    groups = YAML.load_file file
    groups.each do |group,info|
      create_group group,'All Nodes',info['classes'],info['rules'],info['children']
    end
  end
end

mkgroups = Mkgroups.new
mkgroups.create_groups_from_file 'groups.yaml'

