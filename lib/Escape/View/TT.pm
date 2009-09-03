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

This library is free software. You can redistribute it and/or modify
it under the same terms as the Perl Artistic 2.0 license.

See L<http://www.perlfoundation.org/artistic_license_2_0>.

=cut

1;
