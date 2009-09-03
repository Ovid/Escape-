package TestDB::Fixture::User;

use strict;
use warnings;

use TestDB ':all';
require Test::Most;

Test::Most::explain("Loading users");
my $role_rs    = model->resultset('Role');
my $admin_role = $role_rs->create( { role => 'admin' } );
my $user_role  = $role_rs->create( { role => 'user' } );
my $root_role  = $role_rs->create( { role => 'root' } );

my $user_rs = model->resultset('User');
my $user    = $user_rs->create(
    {
        username   => 'user',
        password   => 'pass',
        first_name => 'first_name',
    }
);
my $admin = $user_rs->create(
    {
        username   => 'admin',
        password   => 'pass',
        first_name => 'Admin',
    }
);
my $root = $user_rs->create(
    {
        username   => 'root',
        password   => 'pass',
        first_name => 'Root',
    }
);

my $user_role_rs = model->resultset('UserRole');
$user_role_rs->create(
    {
        user_id => $user->id,
        role_id => $user_role->id,
    }
);
$user_role_rs->create(
    {
        user_id => $admin->id,
        role_id => $admin_role->id,
    }
);
$user_role_rs->create(
    {
        user_id => $root->id,
        role_id => $root_role->id,
    }
);

1;
