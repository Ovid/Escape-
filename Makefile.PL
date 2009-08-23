#!/usr/bin/env perl
use inc::Module::Install;

name 'Escape';
all_from 'lib/Escape.pm';

requires 'Catalyst::Runtime' => '5.80007';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::StackTrace';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Authentication::Realm::SimpleDB';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Helper::View::TT';
requires 'Catalyst::Plugin::Cache' => '0.08';
requires 'parent';
requires
  'Config::General';  # This should reflect the config file format you've chosen
                      # See Catalyst::Plugin::ConfigLoader for supported formats
requires 'Text::Unaccent'             => '1.08';
requires 'Number::Format'             => '1.72';
requires 'HTML::SimpleLinkExtor'      => '1.23';
requires 'DBIx::Class::TimeStamp'     => '0.12';
requires 'DBIx::Class::EncodedColumn' => '0.00002';
requires 'DBD::SQLite'                => '1.25';

# Force this version lest we get the 'Basic auth with colons' errors.
test_requires 'WWW::Mechanize'                 => '1.60';
test_requires 'Test::WWW::Mechanize::Catalyst' => '0.51';
test_requires 'App::Info::RDBMS::SQLite'   => '0.55';

tests join q{ }, map { glob } qw[t/*.t t/controller/*.t];

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
