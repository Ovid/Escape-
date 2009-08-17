use strict;
use warnings;

use lib 't/lib';
use Test::Most 'no_plan', 'die';    # tests => 3;
use HTML::SimpleLinkExtor;
use utf8;

use Catalyst::Test 'Escape';
{
    my %seen = ( '/' => 1 );
    sub get_links {
        my ($base, $request) = @_;
        $base =~ s{/$}{};
        my $parser  = HTML::SimpleLinkExtor->new;
        my $content = $request->content;
        utf8::decode($content);

        # only local links
        no warnings 'uninitialized';
        return
          map  { m{^\w} && ($_ = "$base/$_"); $_ }
          grep { not $seen{$_}++ }
          grep { m{^//} || !m{^\w+://} }
          $parser->parse($content)->links;
    }
}
my %visited;
test_links('/');

sub test_links {
    my @links = @_;
    foreach my $link (@links) {
        ok my $request = request($link), "We should be able to fetch '$link'";
        is $request->code, 200, '... with the correct status code';
        test_links( get_links($link, $request) );
    }
}
