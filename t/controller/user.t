use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Escape' }
BEGIN { use_ok 'Escape::Controller::User' }

ok( request('/user')->is_success, 'Request should succeed' );


