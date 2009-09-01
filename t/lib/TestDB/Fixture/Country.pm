package TestDB::Fixture::Country;

use strict;
use warnings;

use TestDB ':all';
require Test::Most;

my @countries = (
    {
        table => {
            iso        => 'sr',
            url_key    => 'the shire',
            name       => 'The Shire',
            population => 32_987,
            area       => 47_000,
            capital    => 'Bag End',     # XXX who knows?
            wikipedia =>
              'http://en.wikipedia.org/wiki/Shire_%28Middle-earth%29',
        },
    },
    {
        table => {
            iso        => 'rh',
            url_key    => 'rohan',
            name       => 'Rohan',
            population => 1_319_183,
            area       => 618_247,
            capital    => 'Edoras',                             # XXX who knows?
            wikipedia  => 'http://en.wikipedia.org/wiki/Rohan',
        },
    },
);

my $country_rs = model->resultset('Country');
foreach my $country (@countries) {
    Test::Most::explain("Loading country '$country->{table}{name}'");
    my $c = $country_rs->create( $country->{table} );
}

1;
