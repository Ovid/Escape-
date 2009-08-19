package Escape::Schema::Result::UserRole;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "Core");
__PACKAGE__->table("user_role");
__PACKAGE__->add_columns(
  "user_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "role_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("user_id", "role_id");
__PACKAGE__->belongs_to("user_id", "Escape::Schema::Result::User", { id => "user_id" });
__PACKAGE__->belongs_to("role_id", "Escape::Schema::Result::Role", { id => "role_id" });


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-08-19 20:54:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ftO/rJdo40SkuAFOf97OMA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
