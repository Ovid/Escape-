use strict;
use warnings;

use lib 't/lib';
use Test::Most 'no_plan', 'die';    # tests => 3;

use TestDB qw(model fixture login_ok logout_ok);
fixture(qw/user country/);
use Test::WWW::Mechanize::Catalyst 'Escape';
my $mech = Test::WWW::Mechanize::Catalyst->new;

ok $mech->get_ok('/country'), 'Request should succeed';
$mech->content_like( qr/rohan/, 'We probably have some data there' );

$mech->get_ok( '/country/rohan/',
    'We should be able to search for an individual country' );
$mech->content_like( qr/Population/, '... and we have some data' );

$mech->get_ok( '/country/?starts_with=t',
    'We should be able to search with starting letters' );
$mech->content_like( qr/Countries starting with/,
    '... and we should be on the search page' );
$mech->content_like( qr/The Shire/, '... and we have some data' );

$mech->get_ok( '/country/?starts_with=T',
    'Searching on starting letters should be case-insensitive' );
$mech->content_like( qr/Countries starting with/,
    '... and we should be on the search page' );
$mech->content_like( qr/The Shire/, '... and we have some data' );

login_ok $mech, 'user', 'pass', 'We should be able to login as a normal user';
$mech->content_like( qr/first_name/, '... and be logged in' );

$mech->get('/country');
$mech->content_unlike( qr/Add Country/,
    'Normal users should not see an "Add Country" link' );

$mech->get_ok( '/country/?action=create',
    '... but they should be able to specify a create action' );
$mech->content_unlike(
    qr/Enter the name of the country here/,
    '... but not be on the country creation form'
);

login_ok $mech, 'admin', 'pass', 'We should be able to login as an admin user';
$mech->content_like( qr/Admin/, '... and be logged in' );

$mech->get('/country');
$mech->content_like( qr/Add Country/,
    'Admin users should see an "Add Country" link' );

$mech->follow_link_ok( { text_regex => qr/Add Country/ },
    '... and follow said link' );
$mech->content_like(
    qr/Enter the name of the country here/,
    '... and be on the country creation form'
);

$mech->submit_form_ok(
    {
        form_name => 'country_create',
        fields    => {
            name       => 'Mordor',
            capital    => 'Barad-dûr',
            wikipedia  => 'http://en.wikipedia.org/wiki/Mordor',
            iso        => 'mr',
            population => 100_000,
            area       => 200_000,
        },
        button => 'submit',
    },
    'We should be able to create a new country'
);

$mech->get_ok( '/country/mordor/',
    '... and we should be able to fetch the new country page' );
$mech->content_like( qr/200,000/, '... and see reasonable data' );

$mech->get_ok( '/country/mordor/?action=delete',
    'We should be able to try and delete a country' );
ok model->resultset('Country')->find( { url_key => 'mordor' } ),
  '... but not be able to delete it if we are not root';

$mech->get('/country');
login_ok $mech, 'root', 'pass', 'We should be able to login as root';
$mech->get_ok( '/country/mordor/?action=delete',
    '... and try to delete a country' );
ok !model->resultset('Country')->find( { url_key => 'mordor' } ),
  '... and successfully delete the country';
like $mech->uri, qr{^http://[^/]+/country/?$},
    '... and it should redirect us back to the country list';
