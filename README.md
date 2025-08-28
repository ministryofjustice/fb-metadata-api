# README

Application responsible for storing metadata versions for all the services created by the
Ministry of Justice Online Form Builder tool.

Further documentation about requests and responses to and from the API can be found here:

https://ministryofjustice.github.io/form-builder-metadata-api-docs/



## Dependencies

* Docker

## Setup

```
  make setup
```

## Running specs

```
  make spec
```

### Running integration tests only

```
  make integration
```

This spins up the Service Token Cache as well as a Redis instance in order to simulate the
JWT authentication requests. It does not currently create a Kubernetes cluster which is
what underpins the platform apps in production.

A temporary private and public key is generated using `./scripts/seed_test_public_key.rb`
and the public key is put into the Redis instance. All requests made by the integration
tests are signed using the private key.

### Running unit tests only

```
  make all_units
```

## Running load test

We have a script that will stress test all endpoints of the API.

You can install dependencies via homebrew. The dependencies for this script are:

* [Vegeta load test tool](https://github.com/tsenart/vegeta)
* [jq](https://formulae.brew.sh/formula/jq)

The script requires a private key so we can make requests to the
metadata api to sign the JWT access token.

```
   make load-test-local
```
