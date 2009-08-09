package Escape::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    WRAPPER            => 'site/wrapper.tt',
);

=head1 NAME

Escape::View::TT - TT View for Escape

=head1 DESCRIPTION

TT View for Escape. 

=head1 SEE ALSO

L<Escape>

=head1 AUTHOR

Curtis Poe

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
