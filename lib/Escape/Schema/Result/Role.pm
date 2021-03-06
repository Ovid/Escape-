package Escape::Schema::Result::Role;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("role");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "role",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "user_roles",
  "Escape::Schema::Result::UserRole",
  { "foreign.role_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-09-03 15:08:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8HibIa1srT4B7pq2OM7S3w

__PACKAGE__->many_to_many( users => 'user_roles', 'user_id' );

1;
