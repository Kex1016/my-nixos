let carapace_completer = {|spans|
    carapace $spans.0 nushell $spans | from json
}

$env.config = {
    show_banner: false,
    completions: {
    case_sensitive: false # case-sensitive completions
    quick: true    # set to false to prevent auto-selecting completions
    partial: true    # set to false to prevent partial filling of the prompt
    algorithm: "fuzzy"    # prefix or fuzzy
    external: {
    # set to false to prevent nushell looking into $env.PATH to find more suggestions
        enable: true 
    # set to lower can improve completion performance at the cost of omitting some options
        max_results: 100 
        completer: $carapace_completer # check 'carapace_completer' 
        }
    }
}

$env.PATH = ($env.PATH | 
split row (char esep) |
prepend /home/myuser/.apps |
append /usr/bin/env)

# Zoxide nushell integration reimplemented to add to the db when using the `z` command
# For some reason the original implementation doesn't do that? (May be a skill issue.)
def --env __zoxide_z_reimpl [...rest:string] {
  let arg0 = ($rest | append '~').0
  let path = if (($rest | length) <= 1) and ($arg0 == '-' or ($arg0 | path expand | path type) == dir) {
    $arg0
  } else {
    (zoxide query --exclude $env.PWD -- $rest | str trim -r -c "\n")
  }
  cd $path
  zoxide add $path
}

alias z = __zoxide_z_reimpl
