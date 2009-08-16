package Test::XHTML::XPath;
# @(#) $Id: XPath.pm,v 1.10 2005/07/21 20:10:12 dom Exp $

use strict;
use warnings;

use Carp;
use Test::More;
use Test::Builder;

our $VERSION = '0.03';

my $Test = Test::Builder->new;

#---------------------------------------------------------------------
# Import shenanigans.  Copied from Test::Pod...
#---------------------------------------------------------------------

sub import {
    my $self = shift;
    my $caller = caller;

    no strict 'refs';
    *{ $caller . '::is_xpath' }            = \&is_xpath;
    *{ $caller . '::like_xpath' }          = \&like_xpath;
    *{ $caller . '::set_xpath_processor' } = \&set_xpath_processor;
    *{ $caller . '::unlike_xpath' }        = \&unlike_xpath;

    $Test->exported_to( $caller );
    $Test->plan( @_ );
}

#---------------------------------------------------------------------
# Tool.
#---------------------------------------------------------------------

sub like_xpath {
    my ($input, $statement, $test_name) = @_;
    croak "usage: like_xpath(xml,xpath[,name])"
      unless $input && $statement;
    my $ok = eval {
        my $xp = _make_xpath( $input );
        return $xp->exists( $statement );
    };

    if ($@) {
        $Test->ok( 0, $test_name );
        $Test->diag( "  Parse Failure: $@" );
        return 0;
    } else {
        $Test->ok( $ok, $test_name );
        unless ( $ok ) {
            $Test->diag ( "           input: $input" );
            $Test->diag ( "  does not match: $statement" );
        }
        return $ok;
    }
}

sub unlike_xpath {
    my ($input, $statement, $test_name) = @_;
    croak "usage: unlike_xpath(xml,xpath[,name])"
      unless $input && $statement;
    my $ok = eval {
        my $xp = _make_xpath( $input );
        return ! $xp->exists( $statement );
    };
    if ($@) {
        $Test->ok( 0, $test_name );
        $Test->diag( "  Parse Failure: $@" );
        return 0;
    } else {
        $Test->ok( $ok, $test_name );
        unless ( $ok ) {
            $Test->diag ( "       input: $input" );
            $Test->diag ( "  does match: $statement" );
        }
        return $ok;
    }
}

# XXX http://rt.cpan.org/Ticket/Display.html?id=35176
sub is_xpath {
    my ($input, $statement, $expected, $test_name) = @_;
    croak "usage: is_xpath(xml,xpath,expected[,name])"
      unless @_ >= 3;
      #unless $input && $statement && $expected;
    my $got = eval {
        my $xp = _make_xpath( $input );
        $xp->findvalue( $statement );
    };
    if ($@) {
        $Test->ok( 0, $test_name );
        $Test->diag( "  Parse Failure: $@" );
        return 0;
    } else {
        my $retval = $Test->is_eq( $got, $expected, $test_name );
        unless ( $retval ) {
            $Test->diag( "  evaluating: $statement" );
            $Test->diag( "     against: $input" );
        }
        return $retval;
    }
}

#---------------------------------------------------------------------
# Abstract interface to XPath processing.
#---------------------------------------------------------------------

{
    my $xpath_class;
    sub set_xpath_processor {
        $xpath_class = join('::', __PACKAGE__, @_ );
    }
    sub _make_xpath {
        return XML::XPath::XHTML->new( @_ );
    }
}

{
    use strict;
    use warnings;

    package XML::XPath::XHTML;
    use base qw{ Class::Accessor::Fast };

    use XML::LibXML;

    __PACKAGE__->mk_accessors(
        qw{
          xpc
          input
          }
    );

    sub is_xpath_function($) { $_[0] =~ /\A[-[:word:]]+\(/ }

=head2 C<new>

 my $xp = XML::XPath::XHTML->new($xml_string);

Returns a new XPath processing object.

=cut

    sub new {
        my $class = shift;

        my $self = $class->SUPER::new;

        if ( my $document = $self->parse(@_) ) {
            my $xpc =
              XML::LibXML::XPathContext->new( $document->documentElement );
            $xpc->registerNs( x => "http://www.w3.org/1999/xhtml" );
            $self->xpc($xpc);
        }

        return $self;
    }

    sub parse {
        my $self = shift;

        my $parser = XML::LibXML->new();
        $parser->line_numbers(1);

        my $document;

        eval { $document = $parser->parse_string(@_); };
        if ( $@ && $ENV{TEST_VERBOSE} ) {
            warn $@;
        }

        return $document;
    }

=head2 C<exists>

 if ( $xp->exists($xpath) ) {
    ...
 }

Returns a true or false value indicating whether or not a particular xpath
matches.

=cut

    sub exists {
        my ($self) = shift;

        return unless $self->xpc;
        if ( is_xpath_function $_[0] ) {
            my $exists = $self->xpc->findvalue(@_);
            return 'true' eq $exists;
        }

        # call in list context to ensure that we get a list, not a
        # XML::LibXML::NodeList object
        my @exists = $self->xpc->findnodes(@_);
        return scalar @exists;
    }

=head2 C<findvalue>

 if ( $xp->findvalue($xpath) ) {
    ...
 }

Returns the matching value of a particular xpath.  If the xpath is a function,
returns a boolean indicating matching or not, unless said function is designed
to return a value.

For an example of functions, if the following returns 3:

 $xp->findvalue( 'count(/p:pips/p:changes/)' )

Then the following will simply return true:

 $xp->findvalue( 'count(/p:pips/p:changes/)=3' )

This is needed to ensure that our C<*.t> tests still work, but our C<*.yml>
tests work, too.  They behave subtly differently.

=cut

    sub findvalue {
        my $self = shift;

        # make sure xpath functions return booleans
        if ( is_xpath_function $_[0] ) {

          # The second regex is for things like 'count(/p:pips/p:changes)' where
          # we're expected to return a count instead matching a count with
          # 'count(/p:pips/p:changes)=3'

            if ( $_[0] !~ /\A(?:count|local-name)\(.*\)\s*\z/ ) {
                return $self->exists(@_);
            }
        }
        else {

            # make sure non-existent xpaths return undef
            return unless $self->exists(@_);
        }

        # return the values
        return $self->xpc->findvalue(@_);
    }

    1;
}

1;
__END__

=head1 NAME

Test::XML::XPath - Test XPath assertions

=head1 SYNOPSIS

  use Test::XML::XPath tests => 3;
  like_xpath( '<foo />', '/foo' );   # PASS
  like_xpath( '<foo />', '/bar' );   # FAIL
  unlike_xpath( '<foo />', '/bar' ); # PASS

  is_xpath( '<foo>bar</foo>', '/foo', 'bar' ); # PASS
  is_xpath( '<foo>bar</foo>', '/bar', 'foo' ); # FAIL

  # More interesting examples of xpath assertions.
  my $xml = '<foo attrib="1"><bish><bosh args="42">pub</bosh></bish></foo>';

  # Do testing for attributes.
  like_xpath( $xml, '/foo[@attrib="1"]' ); # PASS
  # Find an element anywhere in the document.
  like_xpath( $xml, '//bosh' ); # PASS
  # Both.
  like_xpath( $xml, '//bosh[@args="42"]' ); # PASS

=head1 DESCRIPTION

This module allows you to assert statements about your XML in the form
of XPath statements.  You can say that a piece of XML must contain
certain tags, with so-and-so attributes, etc.  It will try to use any
installed XPath module that it knows about.  Currently, this means
XML::LibXML and XML::XPath, in that order.

B<NB>: Normally in XPath processing, the statement occurs from a
I<context> node.  In the case of like_xpath(), the context node will
always be the root node.  In practice, this means that these two
statements are identical:

   # Absolute path.
   like_xpath( '<foo/>', '/foo' );
   # Path relative to root.
   like_xpath( '<foo/>', 'foo' );

It's probably best to use absolute paths everywhere in order to keep
things simple.

B<NB>: Beware of specifying attributes.  Because they use an @-sign,
perl will complain about trying to interpolate arrays if you don't
escape them or use single quotes.

=head1 FUNCTIONS

=over 4

=item like_xpath ( XML, XPATH [, NAME ] )

Assert that XML (a string containing XML) matches the statement
XPATH.  NAME is the name of the test.

Returns true or false depending upon test success.

=item unlike_xpath ( XML, XPATH [, NAME ] )

This is the reverse of like_xpath().  The test will only pass if XPATH
I<does not> generates any matches in XML.

Returns true or false depending upon test success.

=item is_xpath ( XML, XPATH, EXPECTED [, NAME ] )

Evaluates XPATH against XML, and pass the test if the is EXPECTED.  Uses
findvalue() internally.

Returns true or false depending upon test success.

=item set_xpath_processor ( CLASS )

Set the class name of the XPath processor used.  It is up to you to
ensure that this class is loaded.

=back

In all cases, XML must be well formed, or the test will fail.

=head1 SEE ALSO

L<Test::XML>.

L<XML::XPath>, which is the basis for this module.

If you are not conversant with XPath, there are many tutorials
available on the web.  Google will point you at them.  The first one
that I saw was: L<http://www.zvon.org/xxl/XPathTutorial/>, which
appears to offer interactive XPath as well as the tutorials.

=head1 AUTHOR

Dominic Mitchell E<lt>cpan2 (at) semantico.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2002 by semantico

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut

# Local Variables:
# mode: cperl
# cperl-indent-level: 4
# indent-tabs-mode: nil
# End:
# vim: set ai et sw=4 :

