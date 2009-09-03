package Escape::Controller;

use strict;
use warnings;
use Perl6::Junction 'any';

use parent 'Catalyst::Controller::HTML::FormFu';

sub is_create : Private {
    my ( $self, $c ) = @_;
    return unless $c->check_any_user_role(qw/root admin/);
    return 'create' eq ( $c->req->param('action') || '');
}

sub is_delete : Private {
    my ( $self, $c ) = @_;
    return unless $c->check_any_user_role(qw/root/);
    return 'delete' eq ( $c->req->param('action') || '');
}

sub is_editing : Private {
    my ( $self, $c ) = @_;
    return ( $c->req->param('action') || '') eq any(qw/create edit delete/);
}

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

