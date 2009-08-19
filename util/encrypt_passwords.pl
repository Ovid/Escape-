#!/usr/bin/perl

use strict;
use warnings;

use Escape::Schema;

my $schema = Escape::Schema->connect('dbi:SQLite:db/escape.db');
my @users = $schema->resultset('User')->all;

foreach my $user (@users) {
    print $user->password, $/;
    next;
    $user->password($user->password);
    $user->update;
}
