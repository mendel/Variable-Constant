#!/usr/bin/perl

#TODO tests for arrays

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::Most tests => 8;

use Variable::Constant;

{
  lives_ok {
    my %foo : Constant = (
      "some key" => "some value",
      "other key" => "other value",
    );
  } "assignment to a readonly hash lexical variable in the declaration does not die";
}

{
  my %foo : Constant = (
    "some key" => "some value",
    "other key" => "other value",
  );

  TODO: {
    local $TODO = "Cannot detect which is the last 'store' operation - " .
                  "needs patching Perl.";

    throws_ok {
      %foo = ("something" => "else");
    } qr/^Attempt to assign to a constant variable/,
      "adding a new key to a readonly hash lexical variable just after " .
      "the initial assignment dies";
  }
}

{
  my %foo : Constant = (
    "some key" => "some value",
    "other key" => "other value",
  );

  cmp_deeply(
    \%foo,
    {
      "some key" => "some value",
      "other key" => "other value",
    },
    "the readonly hash lexical variable has the right value"
  );

  throws_ok {
    %foo = ("something" => "else");
  } qr/^Attempt to assign to a constant variable/,
    "reassigning a readonly hash lexical variable after it was read dies";

  throws_ok {
    undef %foo;
  } qr/^Attempt to assign to a constant variable/,
    "undefining a readonly hash lexical variable dies";
}

{
  my %foo : Constant = (
    "some key" => "some value",
    "other key" => "other value",
  );

  throws_ok {
    $foo{"something"} = "else";
  } qr/^Attempt to assign to a constant variable/,
    "adding a new element to a readonly hash lexical variable dies";

  throws_ok {
    $foo{"some key"} = 1;
  } qr/^Attempt to assign to a constant variable/,
    "modifying an element of a readonly hash lexical variable dies";

  throws_ok {
    delete $foo{"other key"};
  } qr/^Attempt to assign to a constant variable/,
    "deleting an element of a readonly hash lexical variable dies";
}
