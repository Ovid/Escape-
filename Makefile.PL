#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;

name 'Escape';
all_from 'lib/Escape.pm';

requires 'Catalyst::Runtime' => '5.80007';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Helper::View::TT';
requires 'Catalyst::Plugin::Cache' => '0.08';
requires 'parent';
requires
  'Config::General';  # This should reflect the config file format you've chosen
                      # See Catalyst::Plugin::ConfigLoader for supported formats
requires 'Text::Unaccent' => '1.08';
requires 'Number::Format' => '1.72';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
