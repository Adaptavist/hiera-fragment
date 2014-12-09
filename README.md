# Hiera::Fragment

The hiera-fragment gem uses deep-merge to merge YAML files together to produce output for Hiera. It is intended to allow
secrets to be specified in separate files (eyaml supported). It also supports replacement of fragments of YAML which
should result in a reduction of size of the configuration for Hiera

## Installation

Install:

    $ gem install hiera-fragment

## Usage

`fragment` should be added as a backend to Hiera. A top-level `:fragment` key is used to configure hiera-fragment

* `:datadir` Array of paths or single path to the fragments.
* `:extensions` Array of extensions to search for.
* `:inputdirs` Array of paths or single path to the source files.
* `:fragments` Array of fragments, specified in the same way as `:hierarchy`
* `:destdir` Directory to ouput modified files to. Defaults to `:yaml[:datadir]`

Only YAML (and eyaml) is currently supported

Example `hiera.yaml` file

    ---
    :backends:
      - fragment
      - yaml

    :hierarchy:
      - source

    :yaml:
      :datadir: ./test/output

    :logger: console

    :fragment:
      :datadir: ./test/fragment
      :extensions:
        - yaml
        - eyaml
      :inputdirs:
        - ./test/input
      :fragments:
        - source
        - foo


Source file:

    ---
    key: 'value'

Fragment file

    ---
    key: 'replaced value'

`hiera -c hiera.yaml key` will output 'replaced value'

