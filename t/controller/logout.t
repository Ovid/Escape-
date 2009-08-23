use strict;
use warnings;
use Test::More tests => 1;

use Catalyst::Test 'Escape';

my $request = request('/logout');
is $request->code, 302, 'Logging out should redirect';
