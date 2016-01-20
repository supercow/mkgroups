$:.unshift File.join(File.dirname(__FILE__),'lib')

require 'mkgroups'
require 'gentree'

require 'yaml'
require 'optparse'

optparse = OptionParser.new { |opts|
  opts.banner =<<-EOF
  Usage: mkgroups <create|delete|generate> [options]

    create - Read from a generated YAML file and create the groups in a local classifier

    delete - Read from a generated YAML file and delete the groups in a local classifier

    generate - Generate a YAML file that can be read by this tool, including random groups and rules

  Options:

EOF

  opts.on('--file','-f','Path to a YAML file for all commands') { |o|  file = o }
  opts.on('--top','-t','The number of top level groups') { |o| num_top = o }
  opts.on('--max_children','-c','Max children per group (excluding grandchildren)') { |o| max_children = o }
  opts.on('--max_depth','-d','The deepest level of inheritance possible in any group') { |o| max_depth = o }
  opts.on('--max_rules','-r','The maximum number of rules to generate in a group') { |o| max_rules = o }

  opts.on('--help','-h') do |o|
    puts opts
    puts
    exit 1
  end

}

optparse.parse!

unless ARGV.size == 1 and ['create','delete','generate'].include?(ARGV[0])
  optparse.parse %w[--help]
end

command = ARGV[0]

file ||= 'groups.yaml'
num_top ||= 40
max_children ||= 3
max_depth ||= 7
max_rules ||= 30

case command
when 'generate'
  f = File.open(file,'w')
  f.write Gentree.create_groups num_top, max_children, max_depth, 'top', max_rules
  f.close
when 'create'
  mkgroups = Mkgroups.new
  mkgroups.create_groups_from_file file
when 'delete'
  mkgroups = Mkgroups.new
  groups = YAML.load_file file
  mkgroups.delete_groups groups
end


