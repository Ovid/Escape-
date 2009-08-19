use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Escape' }
BEGIN { use_ok 'Escape::Controller::Poll' }

ok( request('/poll')->is_success, 'Request should succeed' );


