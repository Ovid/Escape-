use strict;
use warnings;
use Test::More 'no_plan';    # tests => 2;

use lib 't/lib';
use TestDB 'model', 'fixture';
fixture('user');
use Test::WWW::Mechanize::Catalyst 'Escape';
BEGIN { use_ok 'Escape::Controller::Login' }

my $mech = Test::WWW::Mechanize::Catalyst->new;
$mech->get('/country?starts_with=m');
$mech->get_ok( '/login', 'We should be able to fetch our login page' );

$mech->submit_form_ok(
    {
        form_name => 'login',
        fields    => {
            username => 'user',
            password => 'pass',
        }
    },
    '... and complete the login form'
);
$mech->content_contains( 'first_name',
    '... and the page should now have the first_name' );
$mech->get_ok( '/', '... and fetch another page' );
$mech->content_contains( 'first_name', '... and remain logged in' );

$mech->follow_link_ok( { text_regex => qr/Logout/ },
    'We should be able to click the logout link' );
$mech->content_contains( 'Login', '... and be logged out' );
