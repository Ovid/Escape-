use strict;
use warnings;

use lib 't/lib';
use Test::Most 'no_plan';    # tests => 3;

use Catalyst::Test 'Escape';

my $request = request('/search?q=men');
ok $request->is_success, 'Searches should succeed';
my $content = $request->content;
like $content, qr/Turkmenistan/, '... showing reasonable results';
$request = request('/search?q=cot');
like $request->content, qr/C\S+te d'Ivoire/,    # ;)
  '... and does not require accented characters';
$request = request('/search?q=côt');
like $request->content, qr/C\S+te d'Ivoire/,    # ;)
  '... and even ignores the accents';
