use strict;
use warnings;

use lib 't/lib';
use Test::Most 'no_plan','die';    # tests => 3;
use HTML::SimpleLinkExtor;
use utf8;

use Catalyst::Test 'Escape';
{
    my %seen = (
        'http://localhost/'       => 1,
        'http://localhost/static' => 1,     # maybe change this?
    );

    sub get_links {
        my ( $base, $request ) = @_;
        $base =~ s{/$}{};
        my $parser  = HTML::SimpleLinkExtor->new;
        my $content = $request->content;
        utf8::decode($content);

        # only local links
        my @links = $parser->parse($content)->links;
        my @results;
        foreach my $link (@links) {
            no warnings 'uninitialized';
            next if $link !~ m{^https?://localhost/};
            foreach ( url_hack($link) ) {
                s{/$}{};   # cheap normalization
                next if $seen{$_}++;
                push @results => $_;
            }
        }
        return @results;
    }
}

sub url_hack {
    my $link = shift;
    my $orig = $link;
    $link =~ s/\?.*//;    # strip the query string
    my @hacks = grep { $_ } split m{/(?!/)} => $link;
    my @links;
    while ( my $segment = shift @hacks ) {
        no warnings 'uninitialized';
        push @links => $links[-1] . $segment . '/';
    }

    # ok (and safe) to strip the final /
    $links[-1] =~ s{\/$}{};
    push @links => $orig if $orig ne $link;
    shift @links;   # gets rid of http://
    return @links;
}
my %visited;
test_links('/');

sub test_links {
    my @links = @_;
    foreach my $link (@links) {
        diag $link;
        ok my $request = request($link), "We should be able to fetch '$link'";
        is $request->code, 200, '... with the correct status code';
        test_links( get_links( $link, $request ) );
    }
}
