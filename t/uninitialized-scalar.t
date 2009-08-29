#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::Most tests => 5;

use Variable::Constant;

{
  my $foo : Constant;

  throws_ok {
    my $x = $foo;
  } qr/^Attempt to access an uninitialized constant variable/,
    "attempt to access the uninitialized constant variable dies";

  lives_ok {
    $foo = "some text";
  } "can assign to the uninitialized constant variable";

  is($foo, "some text", "the readonly scalar lexical variable has the right value");

  throws_ok {
    $foo = 1;
  } qr/^Attempt to assign to a constant variable/,
    "modifying a readonly scalar lexical variable dies";

  throws_ok {
    undef $foo;
  } qr/^Attempt to assign to a constant variable/,
    "undefining a readonly scalar lexical variable dies";
}
