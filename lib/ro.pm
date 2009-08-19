package ro;

use warnings;
use strict;

=head1 NAME

ro - Readonly variables

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

use Variable::Magic qw(wizard cast);
use Attribute::Handlers;

my %uninitialized_vars;

my $wizard = wizard
  set => sub {
    if (exists $uninitialized_vars{$_[0]}) {
      delete $uninitialized_vars{$_[0]};
    } else {
      die "readonly!"
    }
  };

sub UNIVERSAL::ReadOnly : ATTR(SCALAR,BEGIN)   #TODO array, hash
{
  my ($package, $symbol, $referent, $attr, $data) = @_;

  $uninitialized_vars{$referent} = 1;

  cast $$referent, $wizard;
}


=head1 SYNOPSIS

    use ro;

    my $foo : ReadOnly = 42;
    ...
    $foo = 1;   # dies

=head1 EXPORT

None. But installs a sub (L</ReadOnly> into the L<UNIVERSAL> namespace, that is
a far more grave sin..

=head1 FUNCTIONS

=head2 function1

=cut


=head1 AUTHOR

Norbert Buchmüller, C<< <norbi at nix.hu> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-ro at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=ro>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ro


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=ro>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/ro>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/ro>

=item * Search CPAN

L<http://search.cpan.org/dist/ro/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Norbert Buchmüller, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of ro
