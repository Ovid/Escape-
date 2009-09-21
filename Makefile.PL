#!/usr/bin/env perl
use inc::Module::Install;

name 'Escape';
all_from 'lib/Escape.pm';
license 'artistic_2';
repository 'http://github.com/Ovid/Escape-/tree/master';
bugtracker 'http://github.com/Ovid/Escape-/issues';

requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Authentication::Realm::SimpleDB';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::Controller::HTML::FormFu';
requires 'Catalyst::Helper::View::TT';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::Cache' => '0.08';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Plugin::StackTrace';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Runtime' => '5.80007';
requires 'parent';
requires 'Text::Unaccent'     => '1.08';
requires
  'Config::General';  # This should reflect the config file format you've chosen
                      # See Catalyst::Plugin::ConfigLoader for supported formats
recommends 'IO::Prompt'         => '0.99.4';    # helper script
recommends 'Text::CSV::Encoded' => '0.08';      # helper script

requires 'DBD::SQLite'                => '1.25';
requires 'DBIx::Class::EncodedColumn' => '0.00002';
requires 'DBIx::Class::TimeStamp'     => '0.12';
requires 'HTML::FormFu'               => '0.05001';
requires 'HTML::SimpleLinkExtor'      => '1.23';
requires 'Number::Format'             => '1.72';
requires 'HTML::FormFu::Model::DBIC'  => '0.05002';

test_requires 'App::Info::RDBMS::SQLite'       => '0.55';
test_requires 'Test::Most'                     => '0.21';
test_requires 'Test::WWW::Mechanize::Catalyst' => '0.51';
test_requires 'WWW::Mechanize' => '1.60';    # 'basic auth colon' issue

tests join q{ }, map { glob } qw[t/*.t t/controller/*.t];

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
