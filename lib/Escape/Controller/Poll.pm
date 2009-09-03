package Escape::Controller::Poll;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Escape::Controller::Poll - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Escape::Controller::Poll in Poll.');
}


=head1 AUTHOR

Curtis Poe

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as the Perl Artistic 2.0 license.

See L<http://www.perlfoundation.org/artistic_license_2_0>.

=cut

1;
