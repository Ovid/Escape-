package Escape::Controller::Country;

use strict;
use warnings;
use parent 'Catalyst::Controller';

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

    open my $country_fh, '<', 'notes/list-en1-semic.txt'
      or die "Cannot open notes/list-en1-semic.txt for reading: $!";
    my @countries = map {
        my @country = split ';';
        {
            code => $country[1],
            name => $country[0]
        }
    } <$country_fh>;
    $c->stash->{countries} = \@countries;
}

=head1 AUTHOR

Curtis Poe

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
