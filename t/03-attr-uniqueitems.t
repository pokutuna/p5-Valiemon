use strict;
use warnings;

use Test::More;

use Valiemon;

use_ok 'Valiemon::Attributes::UniqueItems';

subtest 'uniqueItems for scalar' => sub {
    my ($res, $err);
    my $v = Valiemon->new({
        type => 'array',
        uniqueItems => 1,
    });

    ($res, $err) = $v->validate([1,2,3]);
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate([1,2,2]);
    ok !$res;
    is $err->position, '/uniqueItems';
};

subtest 'uniqueItems for object' => sub {
    my ($res, $err);
    my $v = Valiemon->new({
        type => 'array',
        properties => {
            type => { type => 'string' },
        },
        uniqueItems => 1,
    });

    ($res, $err) = $v->validate([{ type => 'passion' }, { type => 'cool' }]);
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate([{ type => 'passion' }, { type => 'passion' }]);
    ok !$res;
    is $err->position, '/uniqueItems';
};

done_testing;
