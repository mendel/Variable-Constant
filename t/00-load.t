#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Variable::Constant' );
}

diag( "Testing Variable::Constant $Variable::Constant::VERSION, Perl $], $^X" );
