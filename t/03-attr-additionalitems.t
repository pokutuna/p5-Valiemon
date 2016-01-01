use strict;
use warnings;

use Test::More;

use Valiemon;

use_ok 'Valiemon::Attributes::AdditionalItems';

subtest 'additionalItems=true' => sub {
    my ($res, $err);
    my $v = Valiemon->new({
        type => 'array',
        items => [ {}, {}, {}],
        additionalItems => 1,
    });

    ($res, $err) = $v->validate([1,2,3]);
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate([1,2,3,'hello']);
    ok $res, 'additionalItems are allowed';
    is $err, undef;
};

subtest 'additionalItems not specified' => sub {
    my ($res, $err);
    my $v = Valiemon->new({
        type => 'array',
        items => [ {}, {}, {}],
    });

    ($res, $err) = $v->validate([1,2,3]);
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate([1,2,3,'hello']);
    ok $res, 'additionalItems are allowed';
    is $err, undef;
};

subtest 'additionalItems=false' => sub {
    my ($res, $err);
    my $v = Valiemon->new({
        type => 'array',
        items => [ {}, {}, {}],
        additionalItems => 0,
    });

    ($res, $err) = $v->validate([1,2,3]);
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate([1,2,3,4,5]);
    ok !$res, 'additional items are not allowed';
    is $err->position, '/additionalItems';
};

subtest 'subschema' => sub {
    my ($res, $err);
    my $v = Valiemon->new({
        type => 'array',
        items => [ {}, {}, {}],
        additionalItems => { type => 'number' },
    });

    ($res, $err) = $v->validate(['foo','bar','baz']);
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate(['foo','bar','baz',4]);
    ok $res, 'Only additional items are validated with `additionalItems`';
    is $err, undef;

    ($res, $err) = $v->validate(['foo','bar','baz','hello']);
    ok !$res;
    is $err->position, '/additionalItems/3/type';
};

subtest 'detect schema error' => sub {
    {
        eval {
            Valiemon->new({
                additionalItems => [],
                items => [{}],
            })->validate([]);
        };
        like $@, qr/`additionalItems` must be/;
    }
    {
        eval {
            Valiemon->new({
                additionalItems => 'hello',
                items => [{}],
            })->validate([]);
        };
        like $@, qr/`additionalItems` must be/;
    }
    {
        eval {
            Valiemon->new({
                additionalItems => { enum => 'invalid' },
                items => [{}],
            })->validate(['','']);
        };
        ok $@;
    }
};

done_testing;
