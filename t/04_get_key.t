use strict;
use warnings;
use Test::More;

BEGIN {
    eval "use Sledge::Exceptions";
    plan $@ ? (skip_all => 'needs Sledge::Exceptions for testing') : (tests => 2);
}

BEGIN { use_ok 'Sledge::Cache' }

{
    package Sledge::Cache::Mock;
    use base qw/Sledge::Cache/;
    sub _init { }
}

{
    package Proj::Pages::Foo;
    use base qw/Class::Accessor/;
}

my $pages = Proj::Pages::Foo->new;
my $cache = Sledge::Cache::Mock->new($pages);
is $cache->_get_key('foo'), 'Proj_foo', '_get_key';

