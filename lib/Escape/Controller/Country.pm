package Escape::Controller::Country;

use strict;
use warnings;
use parent 'Escape::Controller';
use Number::Format;
use HTML::Entities;
use Text::Unaccent;

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
    if ( $c->is_create ) {
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
    my $country = $c->forward( 'get_country', [$country_key] );

    if ( $c->is_delete ) {
        $c->detach( 'country_delete', [$country] );
    }

    $c->stash->{country} = $country;
    my $population = $country->population;
    foreach my $value (qw/population area/) {
        $c->stash->{$value} =
          $c->forward( 'format_number', [ $country->$value ] );
    }

    $c->stash->{title} = $country->name;
}

sub country_create : Action : FormConfig('country_create.yml') {
    my ( $self, $c ) = @_;

    my $form = $c->stash->{form};
    $c->stash->{template} = 'country/create.tt';

    if ( $form->submitted_and_valid ) {
        $form->add_valid(
            url_key => lc( unac_string( 'UTF8', $form->param_value('name') ) )
        );
        my $country = $c->model('DB::Country')->new_result( {} );
        $form->model->update($country);
        $c->flash->{letters}        = '';
        $c->flash->{status_message} = 'Country created';
        $c->response->redirect( $c->uri_for( $self->action_for('index') ) );
    }
}

sub country_delete : Action {
    my ( $self, $c, $country ) = @_;

    $c->response->redirect( $c->uri_for( $self->action_for('index') ) )
      unless $c->check_any_user_role('root');
    my $message = "Country '" . $country->name . "' deleted";
    $country->delete;
    $c->flash->{letters}        = '';
    $c->flash->{status_message} = $message;
    $c->response->redirect( $c->uri_for( $self->action_for('index') ) );
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
it under the same terms as the Perl Artistic 2.0 license.

See L<http://www.perlfoundation.org/artistic_license_2_0>.

=cut

1;
