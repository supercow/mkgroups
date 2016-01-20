require 'yaml'

class Mkgroups::Gengroups
  # Generate an array of NC rules with a random number of rules up to max_rules
  def gen_rules max_rules=30
    rules = []
    for i in 0..(1+rand(max_rules))
      rules << 'or' if rules == []
      rules << ['~',['trusted','certname'],"^blahblahblah#{i}.*$"]
    end
    rules
  end

  # Generate a hash of NC groups to be consumed by mkgroups.rb
  # num_top - the number of groups to create at this level
  # max_children - the maximum number of child groups created
  # max_depth - the deepest number of groups created
  # prefix - don't change this
  #
  # Note that with the default values, this can easily generate over 1000 groups
  def create_groups num_top=40,max_children=3,max_depth=7,prefix='top',max_rules=30
    #puts "create groups #{prefix} #{num_top},#{max_children},#{max_depth}"
    tree = {}
    return {} if max_depth == 0
    for i in 0..num_top
      if prefix == 'top'
        child_prefix = i
      else
        child_prefix = "#{prefix}:#{i}"
      end

      num_groups = 1 + rand(max_children)
      new_depth = max_depth - 1 - rand(max_depth)
      rules = gen_rules max_rules
      tree["Autogroup #{child_prefix}"] = { 'rules' => rules, 'children' => create_groups(num_groups,max_children,new_depth,child_prefix,max_rules), 'classes' => {} }
    end
    tree
  end
end
