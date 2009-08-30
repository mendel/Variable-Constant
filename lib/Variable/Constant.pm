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
  map {
    #TODO reword it to 'Attempt to modify to a constant variable'
    $_ => sub { croak "Attempt to assign to a constant variable"; }
  } qw(set clear copy store delete);

my $uninitialized_constant_wizard;
$uninitialized_constant_wizard = wizard
  map({
    $_ => sub {
      my %dispatch = (
        SCALAR => sub {
          dispell ${$_[0]}, $uninitialized_constant_wizard;
          cast ${$_[0]}, $constant_wizard;
        },
        ARRAY => sub {
          dispell @{$_[0]}, $uninitialized_constant_wizard;
          cast @{$_[0]}, $constant_wizard;
        },
        HASH => sub {
          #dispell %{$_[0]}, $uninitialized_constant_wizard;
          cast %{$_[0]}, $constant_wizard;
        },
      );
      $dispatch{ref($_[0])}->(@_);
    },
  } qw(set store)),
  map({
    $_ => sub { croak "Attempt to access an uninitialized constant variable"; }
  } qw(get len copy dup fetch exists delete));

sub UNIVERSAL::Constant : ATTR(VAR,BEGIN)   #TODO array, hash
{
  my ($package, $symbol, $referent, $attr, $data) = @_;

  my %dispatch = (
    SCALAR => sub { cast ${$referent}, $uninitialized_constant_wizard; },
    ARRAY => sub { cast @{$referent}, $uninitialized_constant_wizard; },
    HASH => sub { cast %{$referent}, $uninitialized_constant_wizard; },
  );
  $dispatch{ref($referent)}->();
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
#TODO for hashes (and probably arrays) there are caveats (you cannnot clear, or completely reassign a hash, you cannot change or delete values, but you can add new keys until it switches to readonly mode - you can force it via reading the hash, eg. 'keys %hash') (in fact constant.pm does no protection of arrayrefs and hashrefs)
#TODO hash write tests: undef %h; %h = (); %h = (foo => 1); $h{existing_key} = 1; $h{existing_key} = the_same_value; undef $h{existing_key}; delete $h{existing_key}; $h{nonexistent_key} = 1; undef $h{nonexistent_key}; delete $h{nonexistent_key}; @h{qw(existing_key)} = (); @h{qw(existing_key)} = (1); delete @h{qw(existing_key)}; @h{qw(nonexistent_key)} = (); @h{qw(nonexistent_key)} = (1); delete @h{qw(nonexistent_key)}; my $hr = \%h; %$hr = (); $hr->{existing_key} = 1;
#TODO hash read tests: my $x = scalar %h; my @a = %h; my @a = keys %h; my @a = values %h; my $x = $h{existing_key}; my $x = $h{nonexistent_key}; my $x = delete $h{existing_key}; my $x = delete $h{nonexistent_key}; my @a = @h{qw(existing_key)}; my @a = @h{qw(nonexistent_key)}; my @a = delete @h{qw(existing_key)}; my @a = delete @h{qw(nonexistent_key)}; my $hr = \%h; my @a = %$hr; my $x = $hr->{existing_key};
#TODO array write tests: undef @a; @a = (); @a = (1); $a[0] = 1; $a[0] = the_same_value; undef $a[0]; delete $a[0]; $a[9] = 1; undef $a[9]; delete $a[9]; @a[0,1] = (); @a[0,1] = (1, 2); delete @a[0,1]; @a[9,10] = (); @a[9,10] = (1, 2); delete @a[9,10]; my $ar = \@a; @$ar = (); $ar->[0] = 1; splice @a, 0, 1; splice @a, 0, 1, (1); push @a, 1; unshift @a, 1;
#TODO array read tests: my @b = @a; my $x = scalar @a; my $x = $a[0]; my $x = $a[9]; my $x = delete $a[0]; my $x = delete $a[9]; my @b = @a[0,1]; my @b = @a[9,10]; my @b = delete @a[0,1]; my @b = delete @a[9,10]; my $ar = \@a; my @b = @$ar; my $x = $ar->[0]; my $x = $ar->[9]; my $x = splice @a, 0, 1; my @b = splice @a, 0, 2; my $x = pop @a; my $x = shift @a; 
#TODO tests and implementation for recursive constant data structures
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
