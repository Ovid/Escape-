package Escape::Controller;

use strict;
use warnings;

use parent 'Catalyst::Controller::HTML::FormFu';

sub format_number : Private {
    my ( $self, $c, $number ) = @_;
    return $number
      ? Number::Format->new(
        -thousands_sep => ',',
        -decimal_point => '.'
      )->format_number($number)
      : '';
}

1;

