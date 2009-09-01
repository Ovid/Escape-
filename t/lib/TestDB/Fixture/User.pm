package TestDB::Fixture::User;

use strict;
use warnings;

use TestDB ':all';
require Test::Most;

Test::Most::explain("Loading user 'user'");
my $user_rs = model->resultset('User');
$user_rs->create(
    {
        username   => 'user',
        password   => 'pass',
        first_name => 'first_name',
    }
);

1;
