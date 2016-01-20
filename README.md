
Ruby script for creating a complex classification hierarchy. This tool is meant
to be used when load testing the PE node classifier.

This script will generate a hierarchy of junk groups with junk rules. The group
structure is recursively generated with random depth, number of children, and
number of rules.

The rules generated are currently only random regex matches to simulate the
effects of pinned nodes.

A sample pre-generated groups.yaml file is included.

## Usage

Generate a groups.yaml file with `mkgroups.rb generate` and add the groups to a classifier with
`mkgroups.rb create`

If you want to remove the generated groups, use `mkgroups.rb delete`. Note that the `delete` command
will only delete the nodes listed in a generated YAML file.

All options except for `--file` and `--help` apply only to the `generate` command.

```

  Usage: mkgroups <create|delete|generate> [options]

    create - Read from a generated YAML file and create the groups in a local classifier

    delete - Read from a generated YAML file and delete the groups in a local classifier

    generate - Generate a YAML file that can be read by this tool, including random groups and rules

  Options:

    -f, --file                       Path to a YAML file for all commands
    -t, --top                        The number of top level groups
    -c, --max_children               Max children per group (excluding grandchildren)
    -d, --max_depth                  The deepest level of inheritance possible in any group
    -r, --max_rules                  The maximum number of rules to generate in a group
    -h, --help
```
