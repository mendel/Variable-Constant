use strict;
use warnings;

#TODO rewrite to use Module::Install
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
        'Variable::Magic' => 0.35,
        'Attribute::Handlers' => 0.79,
        'Scalar::Util' => 1.19,
        'Carp' => 1.08,
    },
    #TODO test deps
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'ro-*' },
);
