use strict;
use Test::More;
use JSON::XS;

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

subtest 'validate properties' => sub {
    my $v = JSON::Schema::Validator->new({
        type => 'object',
        properties => {
            name  => { type => 'string'  },
            price => { type => 'integer' },
        },
    });
    ok  $v->validate({ name => 'fish', price => 300 });
    ok !$v->validate({ name => 'meat', price => [] });
};

subtest 'validate nested properties' => sub {
    my $v = JSON::Schema::Validator->new({
        type => 'object',
        properties => {
            name  => {
                type => 'object',
                properties => {
                    first => { type => 'string' },
                    last  => { type => 'string' },
                    age   => { type => 'integer' },
                },
            },
        },
    });
    ok  $v->validate({
        name => {
            first => 'ane',
            last  => 'hosii',
            age   => 14,
        }
    });
    ok !$v->validate({ name => [] });
    ok !$v->validate({
        name => {
            # none `first`
            last => 'hoge',
            age  => '18',
        }
    });
    ok !$v->validate({
        name => {
            first => 'foo',
            last  => 'bar',
            age   => '1.5',
        }
    });
};

subtest 'validation with $ref refereincing' => sub {
    my $v = JSON::Schema::Validator->new({
        type => 'object',
        definitions => {
            person => {
                type => 'object',
                properties => {
                    first => { type => 'string' },
                    last  => { type => 'string' },
                },
            },
        },
        properties => {
            name => { '$ref' => '#/definitions/person' },
            age  => { type => 'integer' },
        },
    });
    ok $v->validate({
        name => { first => 'foo', last => 'bar' },
        age  => 12
    });
    ok !$v->validate({
        name => { first => 'foo' },
        age  => 10,
    });
};

subtest 'validate with nested $ref referencing' => sub {
    my $v = JSON::Schema::Validator->new({
        type => 'object',
        definitions => {
            person => {
                type => 'object',
                properties => {
                    first   => { type => 'string' },
                    last    => { type => 'string' },
                    address => { '$ref' => '#/definitions/person/definitions/address' },
                },
                definitions => {
                    address => {
                        type   => 'object',
                        properties => {
                            code   => { type => 'integer'},
                            street => { type => 'string'},
                        }
                    },
                },
            },
        },
        properties => {
            person => { '$ref' => '#/definitions/person' },
        },
    });

    ok $v->validate({
        person => {
            first   => 'ababa',
            last    => 'abebe',
            address => { code => 123, street => 'unadon' },
        },
    });

    ok !$v->validate({
        person => {
            first   => 'a',
            last    => 'a',
            address => { code => 345.1, street => 'hamachi' },
        },
    });

    ok !$v->validate({
        person => {
            first   => 'a',
            address => { code => 4, street => 'kegani' },
        },
    });
};

subtest 'validate array (schema)' => sub {
    my $v = JSON::Schema::Validator->new({
        type => 'array',
        items => { type => 'integer' },
    });

    ok  $v->validate([1, 2, 3]);
    ok !$v->validate([1, 2, 3.5]);
    ok !$v->validate([{ a => 'hoge' }]);
};

subtest 'validate array (index)' => sub {
    my $v = JSON::Schema::Validator->new({
        type => 'array',
        items => [{type => 'integer'}, {type => 'object'}, {type => 'array'}],
    });

    ok  $v->validate([1, {}, []]);
    ok !$v->validate([1, [], 3.5]);
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
