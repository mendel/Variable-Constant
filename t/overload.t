#!/usr/bin/perl

# This test is only necessary because of an implementation detail: we have to
# store the references to the constant variables so that we know which of them
# are not initialized yet, and a reference with stringification overload can
# cause troubles there.

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::Most tests => 5;

BEGIN { use_ok('Variable::Constant') };

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
  my $foo_ro : Constant = $foo_rw;

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
