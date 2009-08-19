#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::Most tests => 9;

BEGIN { use_ok('ro') };

{
  my $foo : ReadOnly = "some text";

  is($foo, "some text", "the readonly scalar lexical variable has the right value");

  throws_ok {
    $foo = 1;
  } qr/^readonly!/,
    "modifying a readonly scalar lexical variable dies";

  throws_ok {
    undef $foo;
  } qr/^readonly!/,
    "undefining a readonly scalar lexical variable dies";
}

{
  our $foo : ReadOnly = "some text";

  is($foo, "some text", "the readonly scalar package variable has the right value");

  throws_ok {
    $foo = 1;
  } qr/^readonly!/,
    "modifying a readonly scalar package variable dies";

  throws_ok {
    undef $foo;
  } qr/^readonly!/,
    "undefining a readonly scalar package variable dies";
}

{
  my $foo : ReadOnly;

  lives_ok {
    $foo = 1;
  } "an uninitialized readonly scalar variable can be modified once";

  throws_ok {
    $foo = 2;
  } qr/^readonly!/,
    "an uninitialized readonly scalar variable can be modified only once";
}

#TODO array, hash