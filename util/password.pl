#!/usr/bin/env perl

use strict;
use warnings;
use IO::Prompt;

use Escape::Schema;

my $username = shift || die "No user supplied";
my $schema   = Escape::Schema->connect('dbi:SQLite:db/escape.db');
my @user     = $schema->resultset('User')->search( { username => $username } );

die "No such user ($username)" unless @user;
die "PANIC: Multiple users found for ($username)" if @user > 1;

my $pass1 = prompt( "Enter new password: ", -echo => '*' );
my $pass2 = prompt( "Confirm password:   ", -echo => '*' );

unless ( $pass1 eq $pass2 ) {
    die "Entered passwords don't match";
}
$user[0]->password($pass1);
$user[0]->update;
print "Password updated\n";
