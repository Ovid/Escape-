use strict;
use warnings;
use Test::More 'no_plan';    # tests => 2;

use lib 't/lib';
use TestDB qw/model fixture login_ok logout_ok/;
fixture('user');
use Test::WWW::Mechanize::Catalyst 'Escape';

my $mech = Test::WWW::Mechanize::Catalyst->new;
$mech->get('/country?starts_with=m');
$mech->get_ok( '/login', 'We should be able to fetch our login page' );

login_ok $mech, 'user', 'pass', '... and complete the login form';
$mech->content_contains( 'first_name',
    '... and the page should now have the first_name' );
$mech->get_ok( '/', '... and fetch another page' );
$mech->content_contains( 'first_name', '... and remain logged in' );

logout_ok $mech, 'We should be able to click the logout link';
$mech->content_contains( 'Login', '... and be logged out' );
