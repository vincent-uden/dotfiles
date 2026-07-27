# ESP-IDF activation module for Nushell:
# - Activate with `overlay use export.nu`
# - Deactivate with `deactivate`, as usual
#
# Usage examples:
#   cd /path/to/esp-idf
#   overlay use export.nu
#   idf.py build
#   deactivate
#
# To customize the overlay name, you can call `overlay use export.nu as foo`, but then simply `deactivate` won't work
# because it is just an alias to hide the "export" overlay. You'd need to call `overlay hide foo` manually.
#
# To disable the prompt modification, set: $env.ESP_IDF_DISABLE_PROMPT = true

module warning {
    export-env {
        const file = path self
        error make -u {
            msg: $"`($file | path basename)` is meant to be used with `overlay use`, not `source`"
        }
    }
}

use warning

export-env {
    const script_dir = (path self | path dirname)

    let nu_ver = (version | get version | split row '.' | take 2 | each { into int })
    if $nu_ver.0 == 0 and $nu_ver.1 < 106 {
        error make {
            msg: 'ESP-IDF Nushell activation requires Nushell 0.106 or greater.'
        }
    }

    def has-env [...names] {
        $names | each {|n| $n in $env } | all {|i| $i }
    }

    def is-env-true [name: string] {
        if (has-env $name) {
            let val = ($env | get --optional $name)
            if ($val | describe) == 'bool' {
                $val
            } else {
                not ($val | is-empty)
            }
        } else {
            false
        }
    }

    let idf_path = if (has-env 'IDF_PATH') and (is-env-true 'IDF_PATH_FORCE') {
        $env.IDF_PATH
    } else {
        $script_dir
    }

    let tools_exist = (
        ($idf_path | path join 'tools' 'idf.py' | path exists) and
        ($idf_path | path join 'tools' 'idf_tools.py' | path exists) and
        ($idf_path | path join 'tools' 'activate.py' | path exists)
    )

    if not $tools_exist {
        error make {
            msg: $"Could not automatically detect IDF_PATH. Please navigate to your ESP-IDF directory and run: overlay use export.nu"
        }
    }

    let detect_python_script = ($idf_path | path join 'tools' 'detect_python.sh')
    let esp_python = if ($detect_python_script | path exists) {
        let result = (bash -c $'source "($detect_python_script)" > /dev/null 2>&1 && echo $ESP_PYTHON' | complete)
        if $result.exit_code == 0 {
            $result.stdout | str trim
        } else {
            'python3'
        }
    } else {
        'python3'
    }

    let activate_script = ($idf_path | path join 'tools' 'activate.py')
    let export_output = (^$esp_python $activate_script --export --shell bash | complete)

    if $export_output.exit_code != 0 {
        error make {
            msg: $"Failed to activate ESP-IDF environment: ($export_output.stderr)"
        }
    }

    let export_lines = ($export_output.stdout | lines)
    let source_file = ($export_lines | first | str trim | str replace '. ' '')

    if not ($source_file | path exists) {
        error make {
            msg: $"Activation script file not found: ($source_file)"
        }
    }

    let raw_exports = (open $source_file | lines | where { |line| $line starts-with 'export ' })

    mut new_env = {}

    for line in $raw_exports {
        let parts = ($line | str replace 'export ' '' | parse '{key}="{value}"')
        if ($parts | length) > 0 {
            let key = ($parts | first | get key)
            let value = ($parts | first | get value)
            $new_env = ($new_env | insert $key $value)
        }
    }

    let path_name = if (has-env 'Path') { 'Path' } else { 'PATH' }
    let old_path = ($env | get $path_name)
    let new_path_str = ($new_env | get --optional PATH | default '')

    let new_path = if ($new_path_str | is-empty) {
        $old_path
    } else {
        let expanded_path = ($new_path_str | str replace '$PATH' ($old_path | str join (char esep)))
        ($expanded_path | split row (char esep))
    }

    let esp_idf_version = ($new_env | get --optional ESP_IDF_VERSION | default 'unknown')
    let idf_prompt_name = $'ESP-IDF ($esp_idf_version)'

    mut final_env = { $path_name: $new_path }

    for key in ($new_env | columns) {
        if $key != 'PATH' {
            $final_env = ($final_env | insert $key ($new_env | get $key))
        }
    }

    $final_env = ($final_env | insert ESP_IDF_ACTIVE 'true')

    let esp_idf_prompt_text = $'(ansi green)[(ansi yellow)($idf_prompt_name)(ansi green)](ansi reset) '

    let final_env = if (is-env-true 'ESP_IDF_DISABLE_PROMPT') {
        $final_env
    } else {
        let new_indicator = $'($esp_idf_prompt_text)'
        $final_env
        | insert PROMPT_INDICATOR $new_indicator
    }

    load-env $final_env
}

export alias deactivate = overlay hide export

export alias idf.py = python ([$env.IDF_PATH 'tools' 'idf.py'] | path join)
export alias esptool.py = python -m esptool
export alias espefuse.py = python -m espefuse
export alias espsecure.py = python -m espsecure
export alias otatool.py = python ([$env.IDF_PATH 'components' 'app_update' 'otatool.py'] | path join)
export alias parttool.py = python ([$env.IDF_PATH 'components' 'partition_table' 'parttool.py'] | path join)
