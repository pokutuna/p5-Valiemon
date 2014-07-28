use strict;
use warnings;

use Test::More;

use JSON::Schema::Validator;

use_ok 'JSON::Schema::Validator::Attributes::Items';

subtest 'validate array (schema)' => sub {
    my ($res, $err);
    my $v = JSON::Schema::Validator->new({
        type => 'array',
        items => { type => 'integer' },
    });

    ($res, $err) = $v->validate([1, 2, 3]);
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate([1, 2, 3.5]);
    ok !$res;
    is $err->position, '/items/type';

    ($res, $err) = $v->validate([{ a => 'hoge' }]);
    ok !$res;
    is $err->position, '/items/type';
};

subtest 'validate array (index)' => sub {
    my ($res, $err);
    my $v = JSON::Schema::Validator->new({
        type => 'array',
        items => [{type => 'integer'}, {type => 'object'}, {type => 'array'}],
    });

    ($res, $err) = $v->validate([1, {}, []]);
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate([1, [], 3.5]);
    ok !$res;
    is $err->position, '/items/1/type';
};

done_testing;
