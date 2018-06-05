#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

export BUILDKITE_PLUGIN_CHAMBER_SERVICE=my-service

@test "banner is displayed" {
    stub chamber "export my-service -f dotenv : true"
    run hooks/environment
    unstub chamber
    assert_success
    assert_output "--- :aws-kms: Loading chamber secrets for my-service"
}

@test "error if chamber is missing" {
    run hooks/environment
    assert_failure
    assert_output --partial "chamber: command not found"
}

@test "secrets are exported" {
    stub chamber "export my-service -f dotenv : echo MY_SECRET=foo"
    run bash -c ". hooks/environment && export"
    unstub chamber
    assert_success
    assert_output --partial 'declare -x MY_SECRET="foo"'
}
