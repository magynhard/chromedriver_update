# chromedriver_update
[![Gem](https://img.shields.io/gem/v/chromedriver_update?color=default&style=plastic&logo=ruby&logoColor=red)](https://rubygems.org/gems/chromedriver_update)
![downloads](https://img.shields.io/gem/dt/chromedriver_update?color=blue&style=plastic)
[![License: MIT](https://img.shields.io/badge/License-MIT-gold.svg?style=plastic&logo=mit)](LICENSE)

> Update an existing installation of chromedriver fitting to the current installed version of chrome. Available for Ruby and as CLI command as well.

Very basic tool, to ensure, that the current chromedriver is up to date to the current installed Chrome. Automatically fetches the same driver version or the latest version below, to ensure it will work with the current installed chrome version.

The installed chromedriver is replaced with the new version. So it must have been setup already and added to the PATH environment variable to use this script from then.

Implemented for Linux, Windows and Mac.

### Contents
* [Installation](#installation)
* [Usage](#usage)
* [Command line](#command-line-usage)
* [Documentation](#documentation)
* [Contributing](#contributing)


<a name="installation"></a>
## Installation
### Ruby
Add this line to your application's Gemfile:

```ruby
gem 'chromedriver_update'
```

And then execute:

    bundle install

### Command line
If you just want to use the command line then run

    gem install chromedriver_update

Of course you need to have installed Ruby on your system and set the PATH variable, to have access to Ruby commands like `ruby` or `gem`.



<a name="usage"></a>
## Usage

### Example

```ruby
require 'chromedriver_update'

ChromedriverUpdate.auto_update_chromedriver
```


<a name="command-line-usage"></a>
## Command line

`chromedriver_update` is also available on the command line after installation.

### Example

Run on the command line

```ruby
chromedriver_update
# => Updated Chromedriver from '123.0.0' to '124.0.0'! Chrome is '124.0.1'.
```

<a name="documentation"></a>
## Documentation

For more details have a look at the rubydoc at [https://www.rubydoc.info/gems/chromedriver_update](https://www.rubydoc.info/gems/chromedriver_update)



<a name="documentation"></a>
## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/magynhard/chromedriver_update. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

