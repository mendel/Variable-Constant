package TestMessages;

use strict;
use warnings;

use base qw(Exporter);

use constant {
  MODIFICATION_OF_READONLY_VALUE_ATTEMPTED =>
    qr/^Attempt to assign to a constant variable/,

  READING_OF_UNINITIALIZED_CONSTANT_ATTEMPTED =>
    qr/^Attempt to access an uninitialized constant variable/,
};

our @EXPORT = qw(
  &MODIFICATION_OF_READONLY_VALUE_ATTEMPTED
  &READING_OF_UNINITIALIZED_CONSTANT_ATTEMPTED
);

1;
