#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
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

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
