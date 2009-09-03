package Escape::Schema::Result::UserPoll;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("user_poll");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "user_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "poll_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to("user_id", "Escape::Schema::Result::User", { id => "user_id" });
__PACKAGE__->belongs_to("poll_id", "Escape::Schema::Result::Poll", { id => "poll_id" });


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-09-03 15:08:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ja1gM9MN0lhGagUJ1p9c0Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
