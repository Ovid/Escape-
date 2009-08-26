package Escape::Schema::Result::City;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("city");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "latitude",
  {
    data_type => "FLOAT",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "longitude",
  {
    data_type => "FLOAT",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "region_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "url_key",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "region_id",
  "Escape::Schema::Result::Region",
  { id => "region_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-08-26 12:14:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:p9irAhQ0rexDvBsqiAIpbQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
