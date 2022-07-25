#!/usr/bin/env nu

let REQUIRED_ATTRIBUTES = ["author" "name" "os" "short-desc" "raw-url" "url" "version"]
let DEFAULT_ATTRIBUTES = {"pre-install-msg": "",
    "post-install-msg": "",
    "keywords": [],
    "nu-dependencies": "",
    "installer": "",
    "os": ["android" "macos" "linux" "windows"]
}

# returns record containing script metadata
def get-metadata [
    script: path
] {
    open $script
    |lines -s
    |where $it starts-with '#?'
    |str replace -a -s '#?' ''
    |str collect (char nl)
    |from yaml
}

def check-required-attributes [
    metadata
] {
    let missing-columns = ($REQUIRED_ATTRIBUTES|where $it not-in ($metadata|columns)|str collect ", ")

    if (not ($missing-columns|empty?)) {
        error make {msg: $"Required columns: ($missing-columns) not present in metadata"}
        exit 1
    }

    $REQUIRED_ATTRIBUTES
    |each { |attribute|
        $metadata
        |each { |entry|
            if ($entry|get $attribute|empty?) {
                error make {msg: $"($entry) lacks required attribute: ($attribute)"}
                exit 1
            }
        }
    }
}

def add-optional-attributes [
    metadata
] {
    $DEFAULT_ATTRIBUTES
    |merge {$metadata}
}


ls modules
|each {|module|
    let metadata = (add-optional-attributes (get-metadata $module.name))
    check-required-attributes $metadata
    echo $metadata
}
|save nupac.nuon
