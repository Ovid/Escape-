package Escape::Controller::Country;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Number::Format;
use HTML::Entities;

my @ZOOM_LEVEL;

BEGIN {
    my @areas = qw/
      10000000
      5000000
      1000000
      100000
      10000
      1000
      100
      20
      1
      /;
    # zoom level 14 is closest, 4 is farthest
    foreach my $zoom ( 1 .. @areas - 1 ) {
        push @ZOOM_LEVEL => [ $areas[$zoom] => $zoom + 3 ];
    }
}

=head1 NAME

Escape::Controller::Country - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    if ( defined( my $letters = $c->req->param('starts_with') ) ) {
        $c->detach( 'starts_with', [$letters] );
    }
    $c->stash->{country_rs} =
      $c->model('DB::Country')->search( undef, { order_by => 'name' } );
    $c->stash->{title} ||= 'Countries';
}

sub get_country : Private {
    my ( $self, $c, $country_key ) = @_;
    my $country = $c->model('DB::Country')->find( { url_key => $country_key } );
    unless ($country) {
        $c->stash->{error_message} =
          "Could not find a country for '$country_key'";
        $c->detach('/status_not_found');
    }
    return $country;
}

sub get_region : Private {
    my ( $self, $c, $country, $region_key ) = @_;
    my $region = $c->model('DB::Region')->find(
        {
            url_key    => $region_key,
            country_id => $country->id,
        }
    );
    unless ($region) {
        $c->stash->{error_message} = "Could not find a region for '$region_key'";
        $c->detach('/status_not_found');
    }
    return $region;
}

sub get_city : Private {
    my ( $self, $c, $region, $city_key ) = @_;
    my $city = $c->model('DB::City')->find(
        {
            url_key   => $city_key,
            region_id => $region->id,
        },
    );
    unless ($city) {
        $c->stash->{error_message} = "Could not find a city for '$city_key'";
        $c->detach('/status_not_found');
    }
    return $city;
}

sub country : Path('/country/') : Args(1) {
    my ( $self, $c, $country_key ) = @_;
    my $country = $c->forward('get_country', [$country_key]);
    $c->stash->{country} = $country;
    my $population = $country->population;
    foreach my $value (qw/population area/) {
        $c->stash->{$value} =
          $country->$value
          ? Number::Format->new(
            -thousands_sep => ',',
            -decimal_point => '.'
          )->format_number( $country->$value )
          : '';
    }

    # We don't yet have areas for everything.  Hope this is ok.
    my $area       = $country->area || 0;  
    my $zoom_level = 3;

    # zoom level 14 is closest, 4 is farthest
    foreach my $zoom (reverse @ZOOM_LEVEL) {
        if ( $area < $zoom->[0] ) {
            $zoom_level = $zoom->[1];
            last;
        }
    }

    $c->stash->{zoom_level} = $zoom_level;
    $c->stash->{title}      = $country->name;
    $c->stash->{regions} =
      $country->regions->search( undef, { order_by => 'name' } );
}

sub region : Path('/country/') : Args(2) {
    my ( $self, $c, $country_key, $region_key ) = @_;
    my $country = $c->forward( 'get_country', [$country_key] );
    my $region = $c->forward( 'get_region', [ $country, $region_key ] );

    $c->stash->{cities} = $c->model('DB::City')->search(
        { region_id => $region->id, },
        {
            page => ( $c->req->param('page') || 1 ),
            rows => ( $c->req->param('rows') || 20 ),
            order_by => 'name',
        }
    );
    $c->stash->{region}  = $region;
    $c->stash->{country} = $country;
    $c->stash->{pager}   = $c->stash->{cities}->pager;
}

sub city : Path('/country/') : Args(3) {
    my ( $self, $c, $country_key, $region_key, $city_key ) = @_;
    my $country = $c->forward( 'get_country', [$country_key] );
    my $region  = $c->forward( 'get_region',  [ $country, $region_key ] );
    my $city    = $c->forward( 'get_city',    [ $region, $city_key ] );

    $c->stash->{city}    = $city;
    $c->stash->{region}  = $region;
    $c->stash->{country} = $country;
}

sub starts_with : Private {
    my ( $self, $c, $letter ) = @_;
    $letter = ucfirst( lc($letter) );
    my $countries =
      $c->model('DB::Country')->search( { name => { -like => "$letter%" } } );
    $c->stash->{country_rs} = $countries;
    $c->stash->{template}   = 'country/index.tt';
    $c->stash->{title}      = "Countries starting with '$letter'";
}

=head1 AUTHOR

Curtis Poe

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
