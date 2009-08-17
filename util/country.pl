use strict;
use warnings;

use WWW::Metaweb;
use Escape;
use URI::Escape;
use Text::Unaccent;
`./util/rebuild_model`;
my $schema     = Escape->new->model('Escape')->schema;
my $country_rs = $schema->resultset('Country');

my $mh = WWW::Metaweb->connect(
    server   => 'www.freebase.com',
    auth_uri => '/api/account/login',
    read_uri => '/api/service/mqlread',

    #    write_uri   => '/api/service/mqlwrite',
    trans_uri   => '/api/trans',
    pretty_json => 1
);

open my $country_fh, '<', 'notes/list-en1-semic.txt'
  or die "Cannot open notes/list-en1-semic.txt for reading: $!";
my @countries = map {
    s/\W$//;
    chomp( my @country = split '=' );
    {
        code => $country[1],
        name => $country[0]
    }
} <$country_fh>;

# http://www.freebase.com/app/queryeditor
my $query_template = <<'END_QUERY';
[{
  "type": "/location/country",
  "iso3166_1_alpha2" : "%s",
  "name": null,
  "capital":[],
  "currency_used": [],
  "form_of_government": [],
  "gdp_nominal" : [{"optional":true,"timestamp":null,"currency":null,"amount":null}],
  "official_language":[{"optional":true,"name":null}],
  "/location/statistical_region/population" : [{"optional":true,"number":null,"timestamp":null}],
  "/location/location/area" : { "value": null, "optional": true }
}]
END_QUERY

my $total = @countries;
my $count = 1;
foreach my $country (@countries) {
    my $query = sprintf $query_template => $country->{code};
    print "Adding $country->{name} ($count out of $total)\n";
    my $result = $mh->read( $query, 'perl' ) or die $WWW::Metaweb::errstr;
    next unless @$result;
    $result = $result->[0];
    my $population;
    my $last = '';
    foreach
      my $pop ( @{ $result->{'/location/statistical_region/population'} } )
    {
        $population = $pop->{number} if $pop->{timestamp} ge $last;
        $last = $pop->{timestamp};
    }
    my $area = $result->{"/location/location/area"}{value};
    $count++;
    my $name         = $result->{name};
    my $escaped_name = uri_escape($name);
    $country_rs->create(
        {
            iso        => $country->{code},
            url_key    => lc unac_string( "UTF8", $name ),
            name       => $name,
            population => $population,
            area       => $area,
            capital    => '',
            wikipedia  => "http://en.wikipedia.org/wiki/$escaped_name",
        }
    );
}

__END__
$VAR1 = [
  {
    '/location/statistical_region/population' => [
      {
        'number' => 18013409,
        'timestamp' => '2008-02-06T17:06:38.0002Z'
      },
      {
        'number' => 21075000,
        'timestamp' => '2009-03-29T00:25:27.0000Z'
      }
    ],
    'capital' => [
      'Abidjan',
      'Yamoussoukro'
    ],
    'currency_used' => [
      'West African CFA franc',
      'CFA franc'
    ],
    'form_of_government' => [
      'Republic'
    ],
    'gdp_nominal' => [],
    'iso3166_1_alpha2' => 'CI',
    'name' => "C\x{f4}te d'Ivoire",
    'official_language' => [
      {
        'name' => 'French Language'
      }
    ],
    'type' => '/location/country'
  }
];
=head1
  "gdp_nominal_per_capita" : [{"timestamp":null,"currency":null,"amount":null}],

=cut

my $result = $mh->read( $query, 'perl' ) or die $WWW::Metaweb::errstr;
use Data::Dumper::Simple;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Sortkeys = 1;
print Dumper $result;
print scalar @$result;
