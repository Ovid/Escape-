package Escape::Schema::Result::User;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "InflateColumn::DateTime", "TimeStamp",
    "EncodedColumn", "Core" );
__PACKAGE__->table("user");
__PACKAGE__->add_columns(
    "id",
    {
        data_type     => "INTEGER",
        default_value => undef,
        is_nullable   => 1,
        size          => undef,
    },
    "username",
    {
        data_type     => "TEXT",
        default_value => undef,
        is_nullable   => 1,
        size          => undef,
    },
    "password",
    {
        data_type     => "TEXT",
        default_value => undef,
        is_nullable   => 1,
        size          => undef,
    },
    "email_address",
    {
        data_type     => "TEXT",
        default_value => undef,
        is_nullable   => 1,
        size          => undef,
    },
    "first_name",
    {
        data_type     => "TEXT",
        default_value => undef,
        is_nullable   => 1,
        size          => undef,
    },
    "last_name",
    {
        data_type     => "TEXT",
        default_value => undef,
        is_nullable   => 1,
        size          => undef,
    },
    "active",
    {
        data_type     => "INTEGER",
        default_value => undef,
        is_nullable   => 1,
        size          => undef,
    },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
    "user_roles",
    "Escape::Schema::Result::UserRole",
    { "foreign.user_id" => "self.id" },
);

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-08-18 21:09:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YWueXi7vHx55gO8cIKDZdQ

# You can replace this text with custom content, and it will be preserved on regeneration

__PACKAGE__->many_to_many( roles => 'user_roles', 'role' );

__PACKAGE__->add_columns(
    'password' => {
        data_type     => "TEXT",
        size          => undef,
        encode_column => 1,
        encode_class  => 'Digest',
        encode_args   => {
            algorithm   => 'SHA-1',
            format      => 'hex',
            salt_length => 10
        },
        encode_check_method => 'check_password',
    },
);

1;
