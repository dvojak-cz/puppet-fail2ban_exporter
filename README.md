# maeq-fail2ban_exporter

[![Build Status Travis](https://img.shields.io/travis/com/syberalexis/puppet-fail2ban_exporter/master?label=build%20travis)](https://travis-ci.com/syberalexis/puppet-fail2ban_exporter)
[![Puppet Forge](https://img.shields.io/puppetforge/v/maeq/fail2ban_exporter.svg)](https://forge.puppetlabs.com/maeq/fail2ban_exporter)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/maeq/fail2ban_exporter.svg)](https://forge.puppetlabs.com/maeq/fail2ban_exporter)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/maeq/fail2ban_exporter.svg)](https://forge.puppetlabs.com/maeq/fail2ban_exporter)
[![Apache-2 License](https://img.shields.io/github/license/syberalexis/puppet-fail2ban_exporter.svg)](LICENSE)

#### Table of Contents

- [Description](#description)
- [Usage](#usage)
- [Examples](#examples)
- [Development](#development)

## Description

This module automates the install of [Fail2ban Exporter](https://github.com/Kylapaallikko/fail2ban_exporter).  

## Usage

For more information see [REFERENCE.md](REFERENCE.md).

### Install Fail2ban Exporter

#### Puppet
```puppet
include fail2ban_exporter
```

## Examples

#### Personal python installation

```yaml
fail2ban_exporter::manage_python: false
```

## Development

This project contains tests for [rspec-puppet](http://rspec-puppet.com/).

Quickstart to run all linter and unit tests:
```bash
bundle install --path .vendor/
bundle exec rake test
```
