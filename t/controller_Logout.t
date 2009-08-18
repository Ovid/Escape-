use strict;
use warnings;
use Test::More 'no_plan'; # tests => 3;

use Catalyst::Test 'Escape';
BEGIN { use_ok 'Escape::Controller::Logout' }

my $request = request('/logout');
is $request->code, 302, 'Logging out should redirect';
