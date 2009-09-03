package Escape::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Text::Unaccent;
use Perl6::Junction qw/none/;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in Escape.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

Escape::Controller::Root - Root Controller for Escape

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
}

sub overview : Path('/overview/') : Args(0) {
}

sub license : Path('/license/') : Args(0) {
}

sub technology : Path('/technology/') : Args(0) {
}

sub default : Path {
    my ( $self, $c ) = @_;
    $c->forward('status_not_found');
}

sub status_not_found : Private {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'site/four_oh_four.tt';
    $c->response->status(404);
}

sub search : Local {
    my ( $self, $c ) = @_;
    my $search = lc unac_string( "UTF8", $c->req->param('q') || '' );

    my $term = lc $search;
    $c->stash->{country_rs} = $c->model('DB::Country')->search(
        url_key => { -like => "%$term%" },
        { order_by => 'name' }
    );
    $c->stash->{search} = $search;
}

sub auto : Private {
    my ( $self, $c ) = @_;
    my $cache = $c->cache;
    my $letters;
    unless ( $letters = $cache->get('letters') ) {
        $letters =
          $c->model('DB')
          ->storage->dbh->selectcol_arrayref(
'select distinct(substr(name,1,1)) as letter from country order by letter'
          );
        @$letters = map {
            {
                href    => $c->uri_for( '/country', { starts_with => lc } ),
                display => $_
            }
        } @$letters;
        $cache->set( letters => $letters );
    }

    my $google_api_key;
    unless ( $google_api_key = $cache->get('google_api_key') ) {
        $google_api_key = $c->config->{google_api_key}{ $c->req->hostname };
    }

    # static data we want to cache
    $c->stash->{letters} = $letters;

    if ( $c->req->path eq none(qw/login logout/) ) {
        $c->flash->{path} = $c->req->uri->as_string;
    }
    $c->keep_flash('path');
    return 1;
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {
    my ( $self, $c ) = @_;
}

=head1 AUTHOR

Curtis Poe

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as the Perl Artistic 2.0 license.

See L<http://www.perlfoundation.org/artistic_license_2_0>.

=cut

1;
