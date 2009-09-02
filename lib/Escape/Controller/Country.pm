package Escape::Controller::Country;

use strict;
use warnings;
use parent 'Catalyst::Controller::HTML::FormFu';
use Number::Format;
use HTML::Entities;
use Text::Unaccent;

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

sub is_create : Private {
    my ( $self, $c ) = @_;
    my $roles = $c->user->user_roles;
    while ( my $role = $roles->next ) {
        warn $role->role->role;
    }
    return unless $c->assert_any_user_role(qw/root admin/);
    return 'create' eq ( $c->req->param('action') || '');
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    if ( defined( my $letters = $c->req->param('starts_with') ) ) {
        $c->detach( 'starts_with', [$letters] );
    }
    if ( $c->forward('is_create') ) {
        $c->detach('country_create');
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

sub country : Path('/country') : Args(1) {
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
}

sub country_create :Action :FormConfig('country_create.yml') {
    my ($self, $c) = @_;

    my $form = $c->stash->{form};
    $c->stash->{template} = 'country/create.tt';

    if ($form->submitted_and_valid) {
        $form->add_valid(
            url_key => lc( unac_string( 'UTF8', $form->param_value('name') ) )
        );
        my $country = $c->model('DB::Country')->new_result({});
        $form->model->update($country);
        $c->flash->{status_msg} = 'Country created';
        $c->response->redirect($c->uri_for($self->action_for('index'))); 
        $c->detach;
    } 
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
