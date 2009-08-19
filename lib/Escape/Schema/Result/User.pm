package Escape::Schema::Result::User;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "Core");
__PACKAGE__->table("user");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "username",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "password",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "email_address",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "first_name",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "last_name",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "active",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "user_roles",
  "Escape::Schema::Result::UserRole",
  { "foreign.user_id" => "self.id" },
);
__PACKAGE__->has_many(
  "user_polls",
  "Escape::Schema::Result::UserPoll",
  { "foreign.user_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-08-19 20:54:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4POwXtuLBShxnlPg5PmyZw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
