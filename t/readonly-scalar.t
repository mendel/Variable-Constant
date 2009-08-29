#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib", "$FindBin::Bin/t/lib";

use Test::Most tests => 15;
use TestMessages;

use Variable::Constant;

{
  my $foo : Constant;

  lives_ok {
    $foo = 1;
  } "an uninitialized constant scalar lexical variable can be modified once";

  throws_ok {
    $foo = 2;
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "an uninitialized constant scalar lexical variable cannot be modified after " .
    "the first assignment";
}

{
  our $bar1 : Constant;

  lives_ok {
    $bar1 = 1;
  } "an uninitialized constant scalar package variable can be modified once";

  throws_ok {
    $bar1 = 2;
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "an uninitialized constant scalar package variable cannot be modified after " .
    "the first assignment";
}

{
  lives_ok {
    my $foo : Constant = "some text";
  } "assignment to a constant scalar package variable in the declaration " .
    "does not die";
}

{
  lives_ok {
    our $bar2 : Constant = "some text";
  } "assignment to a constant scalar package variable in the declaration " .
    "does not die";
}

{
  my $foo : Constant = "some text";

  is(
    $foo,
    "some text",
    "the constant scalar lexical variable has the right value"
  );
}

{
  our $bar3 : Constant = "some text";

  is(
    $bar3,
    "some text",
    "the constant scalar package variable has the right value"
  );
}

{
  my $foo : Constant = "some text";

  throws_ok {
    $foo = 1;
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to a constant scalar lexical variable dies";
}

{
  our $bar4 : Constant = "some text";

  throws_ok {
    $bar4 = 1;
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to a constant scalar package variable dies";
}

{
  my $foo : Constant = "some text";

  throws_ok {
    undef $foo;
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "undefining a constant scalar lexical variable dies";
}

{
  our $bar5 : Constant = "some text";

  throws_ok {
    undef $bar5;
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "undefining a constant scalar package variable dies";
}

{
  my $foo : Constant = "some text";
  my $bar = $foo;

  lives_ok {
    $bar = 1;
  } "a copy of a constant constant scalar variable can be modified";
}

{
  lives_ok {
    foreach (1..10) {
      my $foo : Constant = 42;
    }
  } "putting declaration + assignment of a constant constant scalar variable in a loop works";
}

{
  my $foo : Constant = "some text";
  my $foo_ref = \$foo;

  throws_ok {
    $$foo_ref = 1;
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to a constant scalar package variable through a reference dies";
}

