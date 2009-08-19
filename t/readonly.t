#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::Most tests => 9;

BEGIN { use_ok('ro') };

{
  my $foo : ReadOnly = "some text";

  is($foo, "some text", "\$foo has the right value");

  throws_ok {
    $foo = 1;
  } qr/^readonly!/,
    "modifying a readonly value dies";

  throws_ok {
    undef $foo;
  } qr/^readonly!/,
    "undefining a readonly value dies";
}

{
  our $foo : ReadOnly = "some text";

  is($foo, "some text", "\$foo has the right value");

  throws_ok {
    $foo = 1;
  } qr/^readonly!/,
    "modifying a readonly value dies";

  throws_ok {
    undef $foo;
  } qr/^readonly!/,
    "undefining a readonly value dies";
}

{
  my $foo : ReadOnly;

  lives_ok {
    $foo = 1;
  } "an uninitialized readonly variable can be modified once";

  throws_ok {
    $foo = 2;
  } qr/^readonly!/,
    "an uninitialized readonly variable can be modified only once";
}

#TODO array, hash
