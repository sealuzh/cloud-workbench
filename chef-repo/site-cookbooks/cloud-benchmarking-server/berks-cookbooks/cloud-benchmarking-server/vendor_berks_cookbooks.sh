#!/usr/bin/env bash

# Make sure you have berks installed. Run `bundle exec install --without production development test` to install the chef group from the project Gemfile.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

BERKS_BIN=`which berks`
if [ $? -ne 0 ]; then
    echo 'You must install berkshelf:'
    echo 'Run `bundle exec install --without production development test` within the project directory.'
else
    echo "Berkshelf installation detected:"
    echo "Using $BERKS_BIN"
fi

rm -r berks-cookbooks
berks vendor