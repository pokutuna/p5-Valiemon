use strict;
use warnings;

use Test::More;

use_ok 'Valiemon';

subtest 'point' => sub {
    my $v = Valiemon->new({
        type => 'array',
        items => { type => 'integer' },
    });

    is_deeply $v->point($v->schema, ''), $v->schema;
    is_deeply $v->point($v->schema, '/items'), { type => 'integer' };
    is_deeply $v->point($v->schema, '/other'), undef;
};

done_testing;
