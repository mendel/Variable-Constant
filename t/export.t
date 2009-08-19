#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::Most tests => 3;

use PackageThatExportsFoo;

is($foo, "some text", "the exported readonly variable has the right value");

throws_ok {
  $foo = 1;
} qr/^readonly!/,
  "modifying an exported readonly variable dies";

throws_ok {
  undef $foo;
} qr/^readonly!/,
  "undefining an exported readonly variable dies";
