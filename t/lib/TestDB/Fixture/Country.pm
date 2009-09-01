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
        regions => [
            {
                table => {
                    code    => '02',
                    name    => 'Buckland',
                    url_key => 'buckland',
                },
                cities => [
                    {
                        name      => "Bucklebury",
                        latitude  => 0.0,
                        longitude => 0.0,
                        url_key   => 'bucklebury',
                    },
                ],
            },
        ],
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
        regions => [
            {
                table => {
                    code    => '01',
                    name    => 'Westfold',
                    url_key => 'westfold',
                },
                cities => [
                    {
                        name      => "Helm's Deep",
                        latitude  => 0.0,
                        longitude => 0.0,
                        url_key   => 'helms deep',
                    },
                ],
            },
        ],
    },
);

my $country_rs = model->resultset('Country');
my $region_rs  = model->resultset('Region');
my $city_rs    = model->resultset('City');
foreach my $country (@countries) {
    Test::Most::explain("Loading country '$country->{table}{name}'");
    my $c = $country_rs->create( $country->{table} );

    foreach my $region ( @{ $country->{regions} } ) {
        my $data = $region->{table};
        $data->{country_id} = $c->id;
        my $r = $region_rs->create($data);
        foreach my $city ( @{ $region->{cities} } ) {
            $city->{region_id} = $r->id;
            $city_rs->create($city);
        }
    }
}

1;
