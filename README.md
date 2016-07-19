# phantomjs-helper

[![Build status](https://api.travis-ci.org/bergholdt/phantomjs-helper.svg)](https://travis-ci.org/bergholdt/phantomjs-helper)

Easy installation and use of [PhantomJS](http://phantomjs.org).

* [http://github.com/bergholdt/phantomjs-helper](http://github.com/bergholdt/phantomjs-helper)


# Description

`phantomjs-helper` installs an executable, `phantomjs`, in your
gem path.

This script will, if necessary, download the appropriate binary for
your platform and install it into `~/.phantomjs-helper`, then exec
it. Easy peasy!


# Usage

If you're using Bundler, it's as easy as:

    # Gemfile
    gem "phantomjs-helper"

# Updating phantomjs

If you'd like to force-upgrade to the latest version of phantomjs,
run the script `phantomjs-update` that also comes packaged with
this gem.


# Support

The code lives at
[http://github.com/bergholdt/phantomjs-helper](http://github.com/bergholdt/phantomjs-helper).
Open a Github Issue, or send a pull request! Thanks! You're the best.


# License

MIT licensed, see LICENSE.txt for full details.


# Credit

This gem is heavy inspired by http://github.com/flavorjones/chromedriver-helper
