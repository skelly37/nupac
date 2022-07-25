#!/usr/bin/env nu
ls molecule/default/*.yml
|path basename -c [name]
|where name not-in [molecule.yml, prepare.yml]
|each {|test|
    with-env [TEST $test] {
        molecule test
    }
}