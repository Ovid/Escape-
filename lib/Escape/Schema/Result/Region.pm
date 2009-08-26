package Escape::Schema::Result::Region;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("region");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "code",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 2 },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "country_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
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
  "country_id",
  "Escape::Schema::Result::Country",
  { id => "country_id" },
);
__PACKAGE__->has_many(
  "cities",
  "Escape::Schema::Result::City",
  { "foreign.region_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-08-26 12:14:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WlFHgDTlJzI1YOReneS2Wg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
