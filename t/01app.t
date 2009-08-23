#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;

BEGIN {
    use_ok 'Catalyst::Test', 'Escape'
      or BAILOUT("Couldn't load the application!");
}

ok( request('/')->is_success, 'Request should succeed' );
