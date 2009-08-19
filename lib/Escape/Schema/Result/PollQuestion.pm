package Escape::Schema::Result::PollQuestion;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "Core");
__PACKAGE__->table("poll_question");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "question",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "sort_order",
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
__PACKAGE__->belongs_to("poll_id", "Escape::Schema::Result::Poll", { id => "poll_id" });


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-08-19 20:54:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:INbT0MlTYdaSFddmI2D+Gw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
