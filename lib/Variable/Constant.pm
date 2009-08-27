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

=begin private

=head2 croak

Loads L</Carp> and calls L<Carp/croak>. This way L<Carp> is only loaded if this
module is croaking.

=end private

=cut

sub croak
{
  use Carp ();

  goto &Carp::croak;
}

my $constant_wizard = wizard
  set => sub {
    croak "Attempt to assign to a constant variable";
  };

my $uninitialized_constant_wizard;
$uninitialized_constant_wizard = wizard
  set => sub {
    dispell ${$_[0]}, $uninitialized_constant_wizard;
    cast ${$_[0]}, $constant_wizard;
  },
  map {
    $_ => sub { croak "Attempt to access an uninitialized constant variable"; }
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

=cut

#TODO for scalars (and possibly for arrays?) use SvREADONLY (either Internals::SvREADONLY or XS) (after the mode switch, until that use Variable::Magic)
#TODO for hashes use Hash::Util::lock_hash() (knows more about properly locking hashes than plain Internals::SvREADONLY knows) (after the mode switch, until that use Variable::Magic)
#TODO for hashes (and probably arrays) there are caveats (you cannnot clear, or completely reassign a hash, you cannot change or delete values, but you can add new keys until it switches to readonly mode - you can force it via reading the hash, eg. 'keys %hash')
#TODO tests for hash and array slices, array push, pop, shift, unshift, splice, ...
#TODO recursive constant data structures
#TODO tests for readonly-ness after it thrown an exception (either b/c of trying to reassign it or b/c trying to access an uninitialized constant)
#TODO tests for hash and array constant mode switch (ie. from assignable to locked - eg. after a reassignment attempt it should switch to locked state)
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
