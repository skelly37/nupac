#!/usr/bin/env nu
ls modules/
| each {|module|
    nu-check $module.name --as-module
}
| all? $it == true