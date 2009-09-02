use inc::Module::Install 0.91;

name     'Variable-Constant';
all_from 'lib/Variable/Constant.pm';

requires 'Variable::Magic' => 0.35,
requires 'Attribute::Handlers' => 0.79,
requires 'Scalar::Util' => 1.19,
requires 'Carp' => 1.08,

test_requires 'Test::Most' => 0.21;

auto_install;

WriteAll;
