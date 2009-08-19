use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'ro',
    AUTHOR              => 'Norbert Buchmüller <norbi@nix.hu>',
    VERSION_FROM        => 'lib/ro.pm',
    ABSTRACT_FROM       => 'lib/ro.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'ro-*' },
);
