package PackageThatExportsFoo;

use strict;
use warnings;

use base qw(Exporter);
our @EXPORT = qw($foo);

use ro;

our $foo;

BEGIN { $foo = "some text"; }

ro $foo;
