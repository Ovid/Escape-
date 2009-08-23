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

sub country : Path('/country/') : Args(1) {
    my ( $self, $c, $url_key ) = @_;
    my $country = $c->model('DB::Country')->find( { url_key => $url_key } )
       or $c->detach('/status_not_found');
    $c->stash->{country} = encode_entities($country, "\200‐\377");
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
