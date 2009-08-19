#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'ro' );
}

diag( "Testing ro $ro::VERSION, Perl $], $^X" );
