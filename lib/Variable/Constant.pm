package Variable::Constant;

use warnings;
use strict;

=head1 NAME

Variable::Constant - Constant (read-only) variables

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

use Variable::Magic qw(wizard cast dispell);
use Attribute::Handlers;
use Scalar::Util qw(refaddr);

my $constant_wizard = wizard
  set => sub {
    die "readonly!"   #TODO better error msg (faking the exception is thrown from the place where you tried to assign to the readonly variable)
  };

sub uninitialized_constant_access
{
  die "Attempt to access uninitialized constant variable";
}

my $uninitialized_constant_wizard;
$uninitialized_constant_wizard = wizard
  set => sub {
    dispell ${$_[0]}, $uninitialized_constant_wizard;
    cast ${$_[0]}, $constant_wizard;
  },
  map {
    ($_ => \&uninitialized_constant_access)
  } qw(get len copy dup fetch exists delete);

sub UNIVERSAL::Constant : ATTR(SCALAR,BEGIN)   #TODO array, hash
{
  my ($package, $symbol, $referent, $attr, $data) = @_;

  cast $$referent, $uninitialized_constant_wizard;
}


=head1 SYNOPSIS

    use Variable::Constant;

    my $foo : Constant = 42;
    ...
    $foo = 1;   # dies

=head1 EXPORT

None, but installs a sub (L</Constant> into the L<UNIVERSAL> namespace, and
that is a far more grave sin..

=head1 FUNCTIONS

=head2 function1

=cut

#TODO create performance tests (see L<Readonly> dist)
#TODO document performance
#TODO document what Perl version Variable::Magic requires to work properly
#TODO document comparison to L<Readonly>
# * more straightforward syntax
# * there are uninitialized constants - that are declared, but only set on the first assignment, and are readonly only from that point
#TODO document comparison to L<constant> - based on doc from L<Readonly>

=head1 AUTHOR

Norbert Buchmüller, C<< <norbi at nix.hu> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-variable-constant at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Variable-Constant>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Variable::Constant


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Variable-Constant>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Variable-Constant>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Variable-Constant>

=item * Search CPAN

L<http://search.cpan.org/dist/Variable-Constant/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Norbert Buchmüller, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Variable::Constant
