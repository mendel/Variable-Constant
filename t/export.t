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
} qr/^Attempt to assign to a constant variable/,
  "modifying an exported readonly variable dies";

throws_ok {
  undef $foo;
} qr/^Attempt to assign to a constant variable/,
  "undefining an exported readonly variable dies";
