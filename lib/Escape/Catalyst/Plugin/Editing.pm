package Escape::Catalyst::Plugin::Editing;

use strict;
use warnings;
use Perl6::Junction 'any';

sub is_create {
    my ($c) = @_;
    return unless $c->check_any_user_role(qw/root admin/);
    return 'create' eq ( $c->req->param('action') || '' );
}

sub is_delete {
    my ($c) = @_;
    return unless $c->check_any_user_role(qw/root/);
    return 'delete' eq ( $c->req->param('action') || '' );
}

sub is_editing {
    my ($c) = @_;
    return ( $c->req->param('action') || '' ) eq any(qw/create edit delete/);
}

1;
