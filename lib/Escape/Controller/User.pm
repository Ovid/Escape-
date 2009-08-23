package Escape::Controller::User;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Escape::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{user_rs} = $c->model('DB::User')->search;
}

sub user : Path('/user/') : Args(1) {
    my ($self, $c, $user) = @_;
    $c->stash->{user} = $c->model('DB::User')->find({ username => $user })
        or $c->detach('/status_not_found');
}

=head1 AUTHOR

Curtis Poe

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
