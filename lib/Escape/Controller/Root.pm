package Escape::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

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

sub index    : Path               : Args(0) { }
sub overview : Path('/overview/') : Args(0) { }
sub license  : Path('/license/')  : Args(0) { }

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {
    my ($self, $c) = @_;
    my $letters = $c->model('DB')->storage->dbh->selectcol_arrayref(
        'select distinct(substr(name,1,1)) as letter from country order by letter'
    );
    $c->stash->{letters} = $letters;
}

=head1 AUTHOR

Curtis Poe

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
