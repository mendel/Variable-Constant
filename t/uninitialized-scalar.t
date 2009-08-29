#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib", "$FindBin::Bin/t/lib";

use Test::Most tests => 6;
use TestMessages;

use Variable::Constant;

{
  my $foo : Constant;

  throws_ok {
    my $x = $foo;
  } READING_OF_UNINITIALIZED_CONSTANT_ATTEMPTED,
    "attempt to read the uninitialized constant scalar variable dies";

  lives_ok {
    $foo = "some text";
  } "can assign to the uninitialized constant scalar variable even after trying " .
    "to read it";

  is(
    $foo,
    "some text",
    "the originally uninitialized constant scalar variable has the right value " .
    "after the assignment following the attempt to read it"
  );
}

{
  my $foo : Constant;

  throws_ok {
    my $x = $foo;
  } READING_OF_UNINITIALIZED_CONSTANT_ATTEMPTED,
    "attempt to read the uninitialized constant scalar variable dies";

  lives_ok {
    $foo = "some text";
  } "can assign to the uninitialized constant scalar variable even after trying " .
    "to read it";

  throws_ok {
    $foo = 1;
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "the originally uninitialized constant scalar becomes readonly after the " .
    "assignment following the attempt to read it";
}
