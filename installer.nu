#!/usr/bin/env nu

# used to install nupac from PR branch on CI/CD
let default-branch = ($env|get -i NUPAC_DEFAULT_BRANCH|default 'main')

let noconfirm = ($env|get -i NUPAC_NO_CONFIRM|default false|into bool)

let nupac-module = $"https://raw.githubusercontent.com/skelly37/nupac/($default-branch)/modules/nupac.nu"

# Directory where nupac modules will be stored
let install-path = ($env|get -i NUPAC_DEFAULT_LIB_DIRS|default $env.NU_LIB_DIRS.0)

# nupac index
let nu-pkgs = ($install-path|path join 'nu-pkgs.nu')

mkdir $install-path
fetch $nupac-module|save ($install-path|path join ($nupac-module|path basename))

if not ($nu-pkgs|path exists) {
    print 'Creating default nu-pkgs file'

    echo 'use nupac.nu *'
    |save --append $nu-pkgs

    let add-source = ($noconfirm or (input "Do you want to add nu-pkgs to your config.nu file? [y/N] "|$in in ['y' 'Y']))
    if $add-source {
        open $nu.config-path
        |lines
        |append $"source ($nu-pkgs)"
        |str collect (char nl)
        |save $nu.config-path
    } else {
        print 'You will have to source the nu-pkgs file manually'
    }
} else {
    error make {
        msg: 'nu-pkgs already exists.'
    }
}
print 'nupac has been successfully installed'
