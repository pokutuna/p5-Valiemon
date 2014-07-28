use strict;
use warnings;

use Test::More;

use_ok 'JSON::Schema::Validator';

subtest 'validate type' => sub {
    my $v = JSON::Schema::Validator->new({ type => 'object' });
    ok !$v->validate('hello'), 'string is invalid';
    ok !$v->validate([]), 'array is invalid';
    ok !$v->validate(120), 'integer is invalid';
    ok !$v->validate(5.5), 'number is invalid';
    ok !$v->validate(undef), 'null is invalid';
    ok !$v->validate(1), 'boolean is invalid';
    ok  $v->validate({}), 'object is valid!';
};

subtest 'minimum' => sub {
    my $v = JSON::Schema::Validator->new({
        type => 'object',
        properties => {
            year => { type => 'integer', minimum => 1970 },
            age  => { type => 'integer', minimum => 0 },
        },
    });
    ok  $v->validate({ year => 2014, age => 25 });
    ok !$v->validate({ year => 1969, age => 25 });
    ok !$v->validate({ year => 1970, age => -1 });
};

subtest 'minimum & maximum' => sub {
    my $v = JSON::Schema::Validator->new({
        type => 'object',
        properties => {
            year => { type => 'integer', minimum => 1970, exclusiveMinimum => 1 },
            age  => { type => 'integer', minimum => 0, maximum => 3000 },
        },
    });
    ok  $v->validate({ year => 2014, age => 25 });
    ok !$v->validate({ year => 1970, age => 3000 });
    ok !$v->validate({ year => 1971, age => 3001 });
};


done_testing;
