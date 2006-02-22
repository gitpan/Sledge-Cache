use strict;
use warnings;
use Test::More;
use Test::Exception;

BEGIN {
    eval "use Sledge::Exceptions";
    plan $@ ? (skip_all => 'needs Sledge::Exceptions for testing') : (tests => 6);
}

BEGIN { use_ok 'Sledge::Cache' }

can_ok 'Sledge::Cache' => 'new';

for my $method (qw(_init _set _get _remove)) {
    throws_ok { Sledge::Cache->$method } 'Sledge::Exception::AbstractMethod', "$method is abstract method";
}

