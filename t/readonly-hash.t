#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib", "$FindBin::Bin/t/lib";

use Test::Most tests => 8;
use TestMessages;

use Variable::Constant;

#TODO
# @h{qw(existing_key)} = ();
# @h{qw(existing_key)} = (1);
# delete @h{qw(existing_key)};
# @h{qw(nonexistent_key)} = ();
# @h{qw(nonexistent_key)} = (1);
# delete @h{qw(nonexistent_key)};
# todoify some tests and add new tests for current behaviour in cases when the first read triggers turning the hash readonly

# testing modification of the whole hash

{
  my %foo : Constant;

  lives_ok {
    %foo = (
      Larry => "Wall",
      Randal => "Schwartz",
    );
  } "an uninitialized constant hash lexical variable can be assigned to once";

  throws_ok {
    %foo = ( Damian => "Conway" );
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "an uninitialized constant hash lexical variable cannot be assigned to " .
    "after the first assignment";
}

{
  our %bar1 : Constant;

  lives_ok {
    %bar1 = (
      Larry => "Wall",
      Randal => "Schwartz",
    );
  } "an uninitialized constant hash package variable can be assigned to once";

  throws_ok {
    %bar1 = ( Damian => "Conway" );
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "an uninitialized constant hash package variable cannot be assigned to " .
    "after the first assignment";
}

{
  my %foo : Constant;

  lives_ok {
    %foo = (
      Larry => "Wall",
      Randal => "Schwartz",
    );
  } "an uninitialized constant hash lexical variable can be assigned to once";

  throws_ok {
    %foo = (
      Larry => "Wall",
      Randal => "Schwartz",
    );
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "an uninitialized constant hash lexical variable cannot be assigned to " .
    "after the first assignment - not even setting to the same value";
}

{
  our %bar2 : Constant;

  lives_ok {
    %bar2 = (
      Larry => "Wall",
      Randal => "Schwartz",
    );
  } "an uninitialized constant hash package variable can be assigned to once";

  throws_ok {
    %bar2 = (
      Larry => "Wall",
      Randal => "Schwartz",
    );
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "an uninitialized constant hash package variable cannot be assigned to " .
    "after the first assignment - not even setting to the same value";
}

{
  lives_ok {
    my %foo : Constant = (
      Larry => "Wall",
      Randal => "Schwartz",
    );
  } "assignment to a constant hash package variable in the declaration " .
    "does not die";
}

{
  lives_ok {
    our %bar3 : Constant = (
      Larry => "Wall",
      Randal => "Schwartz",
    );
  } "assignment to a constant hash package variable in the declaration " .
    "does not die";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  cmp_deeply(
    \%foo,
    {
      Larry => "Wall",
      Randal => "Schwartz",
    },
    "the constant hash lexical variable has the right value"
  );
}

{
  our %bar4 : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  cmp_deeply(
    %bar4,
    {
      Larry => "Wall",
      Randal => "Schwartz",
    },
    "the constant hash package variable has the right value"
  );
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    %foo = ();
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning the empty list to a constant hash lexical variable dies";
}

{
  our %bar5 : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    %bar5 = ();
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning the empty list to a constant hash package variable dies";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    %foo = ( Damian => "Conway" );
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to a constant hash lexical variable dies";
}

{
  our %bar6 : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    %bar6 = ( Damian => "Conway" );
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to a constant hash package variable dies";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    undef %foo;
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "undefining a constant hash lexical variable dies";
}

{
  our %bar7 : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    undef %bar7;
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "undefining a constant hash package variable dies";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );
  my %bar = %foo;

  lives_ok {
    %bar = ( Damian => "Conway" );
  } "a copy of a constant constant hash variable can be modified";
}

{
  lives_ok {
    foreach (1..10) {
      my %foo : Constant = (
        Larry => "Wall",
        Randal => "Schwartz",
      );
    }
  } "putting declaration + assignment of a constant constant hash lexical " .
    "variable in a loop works";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );
  my $foo_ref = \%foo;

  throws_ok {
    %$foo_ref = ( Damian => "Conway" );
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to a constant hash variable through a reference dies";
}


# testing modification of a hash slice

{
  my %foo : Constant;

  lives_ok {
    %foo = (
      Larry => "Wall",
      Randal => "Schwartz",
    );
  } "an uninitialized constant hash lexical variable can be assigned to once";

  throws_ok {
    @foo{qw(Larry Randal)} = ( "van Rossum", "Matsumoto" );
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "a slice of an uninitialized constant hash lexical variable cannot be " .
    "assigned to after the first assignment";
}

{
  our %bar8 : Constant;

  lives_ok {
    %bar8 = (
      Larry => "Wall",
      Randal => "Schwartz",
    );
  } "an uninitialized constant hash package variable can be assigned to once";

  throws_ok {
    @bar8{qw(Larry Randal)} = ( "van Rossum", "Matsumoto" );
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "a slice of an uninitialized constant hash package variable cannot be " .
    "assigned to after the first assignment";
}

{
  my %foo : Constant;

  lives_ok {
    %foo = (
      Larry => "Wall",
      Randal => "Schwartz",
    );
  } "an uninitialized constant hash lexical variable can be assigned to once";

  throws_ok {
    @foo{qw(Larry Randal)} = ( "Wall", "Schwartz" );
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "an uninitialized constant hash lexical variable cannot be assigned to " .
    "after the first assignment - not even setting to the same value";
}

{
  our %bar9 : Constant;

  lives_ok {
    %bar9 = (
      Larry => "Wall",
      Randal => "Schwartz",
    );
  } "an uninitialized constant hash package variable can be assigned to once";

  throws_ok {
    @bar9{qw(Larry Randal)} = ( "Wall", "Schwartz" );
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "an uninitialized constant hash package variable cannot be assigned to " .
    "after the first assignment - not even setting to the same value";
}

{
  my %foo : Constant;

  lives_ok {
    @foo{qw(Larry Randal)} = ( "Wall", "Schwartz" );
  } "a slice of an uninitialized constant hash lexical variable can be assigned " .
    "to once";

  cmp_deeply(
    \%foo,
    {
      Larry => "Wall",
      Randal => "Schwartz",
    },
    "the constant hash lexical variable has the right value"
  );
}

{
  our %bar11 : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  cmp_deeply(
    %bar11,
    {
      Larry => "Wall",
      Randal => "Schwartz",
    },
    "the constant hash package variable has the right value"
  );
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    %foo = ();
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning the empty list to a constant hash lexical variable dies";
}

{
  our %bar12 : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    %bar12 = ();
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning the empty list to a constant hash package variable dies";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    %foo = ( Damian => "Conway" );
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to a constant hash lexical variable dies";
}

{
  our %bar13 : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    %bar13 = ( Damian => "Conway" );
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to a constant hash package variable dies";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    undef %foo;
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "undefining a constant hash lexical variable dies";
}

{
  our %bar14 : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    undef %bar14;
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "undefining a constant hash package variable dies";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );
  my %bar = %foo;

  lives_ok {
    %bar = ( Damian => "Conway" );
  } "a copy of a constant constant hash variable can be modified";
}

{
  lives_ok {
    foreach (1..10) {
      my %foo : Constant = (
        Larry => "Wall",
        Randal => "Schwartz",
      );
    }
  } "putting declaration + assignment of a constant constant hash lexical " .
    "variable in a loop works";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );
  my $foo_ref = \%foo;

  throws_ok {
    %$foo_ref = ( Damian => "Conway" );
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to a constant hash variable through a reference dies";
}



# testing modification of a single hash element

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    $foo{Larry} = "van Rossum";
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to an element of a constant hash lexical variable dies";
}

{
  our %bar15 : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    $bar15{Larry} = "van Rossum";
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to an element of a constant hash package variable dies";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    $foo{Larry} = "Wall";
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to an element of a constant hash lexical variable dies - " .
    "even if setting to the same value";
}

{
  our %bar16 : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    $bar16{Larry} = "Wall";
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to an element of a constant hash package variable dies - " .
    "even if setting to the same value";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    undef $foo{Larry};
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "undefining an element of a constant hash lexical variable dies";
}

{
  our %bar17 : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    undef $bar17{Larry};
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "undefining an element of a constant hash package variable dies";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    delete $foo{Larry};
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "deleting an element of a constant hash lexical variable dies";
}

{
  our %bar18 : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    delete $bar18{Larry};
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "deleting an element of a constant hash package variable dies";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    $foo{Yukihiro} = "van Rossum";
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to a non-existent an element of a constant hash lexical variable dies";
}

{
  our %bar19 : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    $bar19{Yukihiro} = "van Rossum";
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to a non-existent an element of a constant hash package variable dies";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    undef $foo{Yukihiro};
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "undefining a non-existent an element of a constant hash lexical variable dies";
}

{
  our %bar20 : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    undef $bar20{Yukihiro};
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "undefining a non-existent an element of a constant hash package variable dies";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    delete $foo{Yukihiro};
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "deleting a non-existent an element of a constant hash lexical variable dies";
}

{
  our %bar21 : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );

  throws_ok {
    delete $bar21{Yukihiro};
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "deleting a non-existent an element of a constant hash package variable dies";
}

{
  my %foo : Constant;

  lives_ok {
    $foo{Larry} = "Wall";
  } "an non-existent element of an uninitialized constant constant hash " .
    "variable can be created";

  throws_ok {
    $foo{Randal} = "Schwartz";
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to an element of a constant hash lexical variable dies";
}

{
  our %bar22 : Constant;

  lives_ok {
    $bar22{Larry} = "Wall";
  } "an non-existent element of an uninitialized constant constant hash " .
    "variable can be created";

  throws_ok {
    $bar22{Randal} = "Schwartz";
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to an element of a constant hash package variable dies";
}

{
  my %foo : Constant = (
    Larry => "Wall",
    Randal => "Schwartz",
  );
  my $foo_ref = \%foo;

  throws_ok {
    $foo_ref->{Larry} = "van Rossum";
  } MODIFICATION_OF_READONLY_VALUE_ATTEMPTED,
    "assigning to an element of a constant hash lexical variable through a " .
    "reference dies";
}
