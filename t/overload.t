#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::Most tests => 5;

BEGIN { use_ok('ro') };

{
  {
    package Foo;

    use overload
      '""' => sub { "some text" };

    sub new
    {
      return bless {}, shift;
    }
  }

  my $foo_rw = Foo->new();
  my $foo_ro : ReadOnly = $foo_rw;

  is(
    $foo_ro,
    "some text",
    "the readonly scalar lexical variable stringifies to the right value"
  );

  throws_ok {
    $foo_ro = 1;
  } qr/^readonly!/,
    "modifying the readonly scalar lexical variable dies";

  throws_ok {
    undef $foo_ro;
  } qr/^readonly!/,
    "undefining the readonly scalar lexical variable dies";

  lives_ok {
    $foo_rw = 1;
  } "modifying the readwrite scalar lexical variable does not die";
}
