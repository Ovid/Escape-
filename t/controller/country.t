use strict;
use warnings;

use lib 't/lib';
use Test::Most 'no_plan', 'die';    # tests => 3;

use TestDB qw(fixture);
fixture(qw/user country/);
use Catalyst::Test 'Escape';

my $request = request('/country');
ok $request->is_success, 'Request should succeed';
my $content = $request->content;
explain "Got content";
like $content, qr/rohan/, 'We probably have some data there';

$request = request('/country/rohan/');
ok $request->is_success,
  'We should be able to search for an individual country';
$content = $request->content;
explain "Got content";
like $content, qr/Population/, '... and we have some data';

$request = request('/country/?starts_with=t');
ok $request->is_success, 'We should be able to search with starting letters';
$content = $request->content;
like $content, qr/Countries starting with/,
  '... and we should be on the search page';
like $content, qr/The Shire/, '... and we have some data';
$request = request('/country/?starts_with=T');
ok $request->is_success, 'Regardless of case';
$content = $request->content;
like $content, qr/Countries starting with/,
  '... and we should be on the search page';
like $content, qr/The Shire/, '... and we have some data';
