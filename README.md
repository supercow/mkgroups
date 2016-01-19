
Ruby script for creating a complex classification hierarchy

## Usage

Generate a groups.yaml file with gentree.rb and use it as input to mkgroups.rb

### gentree.rb

Generate a YAML file describing groups, child groups, and rules. All groups and
children are randomly generated based on parameters passed to `gen_rules` and
`create_groups`.

The resulting YAML file is written to STDOUT.

### mkgroups.rb

Creates classification groups on the locally configured classifier by reading
from the local file `groups.yaml`

Must be run on the CA.
