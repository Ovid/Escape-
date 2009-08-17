package Escape;

use strict;
use warnings;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use parent qw/Catalyst/;
#use Catalyst qw/-Debug
use Catalyst qw/
  Cache
  ConfigLoader
  Static::Simple/;
our $VERSION = '0.03';

# Configure the application.
#
# Note that settings in escape.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config->{'Plugin::Cache'}{backend} = {
        class   => "Catalyst::Plugin::Cache::Backend::Memory",
        #debug   => 2,
    };

__PACKAGE__->config( 'Plugin::ConfigLoader' => { file => 'db/escape.conf' } );

# Start the application
__PACKAGE__->setup();

=head1 NAME

Escape - Catalyst based application

=head1 SYNOPSIS

    script/escape_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Escape::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Curtis Poe

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
