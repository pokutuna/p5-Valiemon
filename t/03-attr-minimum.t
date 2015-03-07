use strict;
use warnings;
use Test::More;

use Valiemon;


subtest 'minimum' => sub {
    my ($res, $err);
    my $v = Valiemon->new({
        type => 'integer',
        minimum => 3,
    });
    ($res, $err) = $v->validate(4);
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate(3);
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate(2);
    ok !$res;
    is $err->position, '/minimum';
};

subtest 'minimum with exclusiveMinimum' => sub {
    my ($res, $err);
    my $v = Valiemon->new({
        type => 'integer',
        minimum => 3,
        exclusiveMinimum => 1,
    });
    ($res, $err) = $v->validate(4);
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate(3);
    ok !$res;
    is $err->position, '/minimum';

    ($res, $err) = $v->validate(2);
    ok !$res;
    is $err->position, '/minimum';
};

subtest 'minimum with object propertie' => sub {
    my ($res, $err);
    my $v = Valiemon->new({
        type => 'object',
        properties => {
            year => { type => 'integer', minimum => 1970 },
            age  => { type => 'integer', minimum => 0 },
        },
    });
    ($res, $err) = $v->validate({ year => 2014, age => 25 });
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate({ year => 1969, age => 25 });
    ok !$res;
    is $err->position, '/properties/year/minimum';

    ($res, $err) = $v->validate({ year => 1970, age => -1 });
    ok !$res;
    is $err->position, '/properties/age/minimum';
};

done_testing;
