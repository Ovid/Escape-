package TestDB;

use strict;
use warnings;

use DBI;

use base 'Exporter';

our @EXPORT_OK = qw(
  fixture
  model
  dbi
  dsn
);
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

=head1 NAME

TestDB - Quick hack to override the database

=head1 SYNOPSIS

 use TestDB;
 use Test::WWW::Mechanize::Catalyst 'Escape';

The test database I<must> be loaded before Escape is.

=cut

use App::Info::RDBMS::SQLite;
use File::Temp 'tempfile';

sub _confess($) {
    require Carp;
    Carp::confess shift;
}

BEGIN {
    if ( exists $INC{'Escape/Model/DB/pm'} ) {
        _confess __PACKAGE__ . ". must be loaded prior to Escape::Model::DB";
    }

    my $sqlite = App::Info::RDBMS::SQLite->new;
    if ( not $sqlite->installed ) {
        _confess "App::Info::RDBMS::SQLite does not think SQLite is installed";
    }

    if ( $sqlite->major_version < 3 ) {
        my $version = $sqlite->version;
        _confess "You need SQLite version 3 or better, not '$version'";
    }

    my $executable = $sqlite->executable;
    my $schema     = 'db/full_schema.sql';
    my ( undef, $filename ) = tempfile();
    system("$executable $filename < $schema") == 0
      or _confess "Cannot load $schema into $filename: $?";

    my $dsn = $ENV{ESCAPE_TEST_DSN} = "dbi:SQLite:$filename";
    sub dsn { $dsn }

    my $dbh = DBI->connect($dsn);
    sub dbh { $dbh }
}

use Escape;
my $model = Escape->new->model('DB');
sub model { $model }

sub fixture {
    my (@fixtures) = @_;
    foreach my $fixture (@fixtures) {
        my $short = $fixture;
        $fixture = 'TestDB::Fixture::' . ucfirst $fixture;
        eval "use $fixture";
        if ( my $error = $@ ) {
            $error = "Could not load ($fixture) for ($short): $error";
            _confess $error;
        }
    }
}

1;
