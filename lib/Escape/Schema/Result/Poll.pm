package Escape::Schema::Result::Poll;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "Core");
__PACKAGE__->table("poll");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "title",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "date",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "poll_questions",
  "Escape::Schema::Result::PollQuestion",
  { "foreign.poll_id" => "self.id" },
);
__PACKAGE__->has_many(
  "user_polls",
  "Escape::Schema::Result::UserPoll",
  { "foreign.poll_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-08-19 20:54:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hS2k7PLUMECw9uOEWfsCgw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
