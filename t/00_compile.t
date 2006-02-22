use strict;
use warnings;
use Test::More;

BEGIN {
    eval "use Sledge::Exceptions";
    plan $@ ? (skip_all => 'needs Sledge::Exceptions for testing') : (tests => 1);
}

BEGIN { use_ok 'Sledge::Cache' }
