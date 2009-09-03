package Escape;

use strict;
use warnings;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory

use parent qw/Catalyst/;
#use Catalyst qw/-Debug
use Catalyst qw/
  Cache
  ConfigLoader
  Static::Simple

  StackTrace

  Authentication
  Authorization::Roles

  Session
  Session::Store::FastMmap
  Session::State::Cookie
  /;
our $VERSION = '0.05';

# Configure the application.
#
# Note that settings in escape.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config->{'Plugin::Cache'}{backend} = {
    class => "Catalyst::Plugin::Cache::Backend::Memory",
    #debug   => 2,
};

# Configure SimpleDB Authentication
__PACKAGE__->config->{'Plugin::Authentication'} = {
    default => {
        class         => 'SimpleDB',
        user_model    => 'DB::User',
        password_type => 'self_check',
    },
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
it under the same terms as the Perl Artistic 2.0 license.

See L<http://www.perlfoundation.org/artistic_license_2_0>.

=cut

1;
