use strict;
use warnings;
use Test::More tests => 2;

use Catalyst::Test 'Escape';
BEGIN { use_ok 'Escape::Controller::Login' }

ok( request('/login')->is_success, 'Request should succeed' );
