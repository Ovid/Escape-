use strict;
use warnings;

use lib 't/lib';
use Test::Most 'no_plan';    # tests => 3;

use Catalyst::Test 'Escape';

my $request = request('/country');
ok $request->is_success, 'Request should succeed';
my $content = $request->content;
explain "Got content";
like $content, qr/afghanistan/, 'We probably have some data there';

$request = request('/country/afghanistan/');
ok $request->is_success,
  'We should be able to search for an individual country';
$content = $request->content;
explain "Got content";
like $content, qr/Population/, '... and we have some data';

$request = request('/country/?starts_with=af');
ok $request->is_success, 'We should be able to search with starting letters';
$content = $request->content;
like $content, qr/Countries starting with/,
  '... and we should be on the search page';
like $content, qr/Afghanistan/, '... and we have some data';
$request = request('/country/?starts_with=AF');
ok $request->is_success, 'Regardless of case';
$content = $request->content;
like $content, qr/Countries starting with/,
  '... and we should be on the search page';
like $content, qr/Afghanistan/, '... and we have some data';
