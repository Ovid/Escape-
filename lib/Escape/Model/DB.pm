package Escape::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'Escape::Schema',
    
    connect_info => {
        dsn => 'dbi:SQLite:escape.db',
        user => '',
        password => '',
    }
);

=head1 NAME

Escape::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<Escape>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Escape::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.26

=head1 AUTHOR

Curtis Poe

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
