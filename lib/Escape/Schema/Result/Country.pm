package Escape::Schema::Result::Country;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("country");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "iso",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 2 },
  "url_key",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "population",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "area",
  {
    data_type => "FLOAT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "capital",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "wikipedia",
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
    is_nullable => 1,
    size => undef,
  },
  "longitude",
  {
    data_type => "FLOAT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "google_zoom",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-09-03 15:08:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:feUK1P/EGTqt25YU3k8gXw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
