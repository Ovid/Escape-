package Escape::Controller::Country;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Number::Format;

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
    $c->stash->{country_rs} = $c->model('DB::Country');
}

sub country : Path('/country/') : Args(1) {
    my ( $self, $c, $url_key ) = @_;
    my $country = $c->model('DB::Country')->find( { url_key => $url_key } );
    $c->stash->{country} = $country;
    $c->stash->{population} =
      Number::Format->new( -thousands_sep => ',' )
      ->format_number( $country->population );

}

=head1 AUTHOR

Curtis Poe

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
