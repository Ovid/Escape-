use strict;
use warnings;

use lib 't/lib';
use Test::Most 'no_plan'; # tests => 3;
use Test::XHTML::XPath;

BEGIN { use_ok 'Catalyst::Test', 'Escape' }
BEGIN { use_ok 'Escape::Controller::Country' }

my $request = request('/country');
ok $request->is_success, 'Request should succeed';
my $content = $request->content;
explain "Got content";
like_xpath $content, '/x:html/x:body', 'We have an XHTML document';
#"id('NF')", 'NORFOLK ISLAND';
