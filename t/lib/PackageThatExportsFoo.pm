package PackageThatExportsFoo;

use strict;
use warnings;

use base qw(Exporter);
our @EXPORT = qw($foo);

use Variable::Constant;

our $foo : Constant = "some text";

1;
