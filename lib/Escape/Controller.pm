package Escape::Controller;

use strict;
use warnings;

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

1;

