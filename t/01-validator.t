use strict;
use Test::More;
use JSON::XS;

use_ok 'JSON::Schema::Validator';

subtest 'validate type' => sub {
    my $validator = JSON::Schema::Validator->new({ type => 'object' });
    ok !$validator->validate('hello'), 'string is invalid';
    ok !$validator->validate([]), 'array is invalid';
    ok !$validator->validate(120), 'integer is invalid';
    ok !$validator->validate(5.5), 'number is invalid';
    ok !$validator->validate(undef), 'null is invalid';
    ok !$validator->validate(1), 'boolean is invalid';
    ok  $validator->validate({}), 'object is valid!';
};

subtest 'validate properties' => sub {
    my $validator = JSON::Schema::Validator->new({
        type => 'object',
        properties => {
            name  => { type => 'string'  },
            price => { type => 'integer' },
        },
    });
    ok  $validator->validate({ name => 'fish', price => 300 });
    ok !$validator->validate({ name => 'meat', price => [] });
};

subtest 'validate nested properties' => sub {
    my $validator = JSON::Schema::Validator->new({
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
    ok  $validator->validate({
        name => {
            first => 'ane',
            last  => 'hosii',
            age   => 14,
        }
    });
    ok !$validator->validate({ name => [] });
    ok !$validator->validate({
        name => {
            # none `first`
            last => 'hoge',
            age  => '18',
        }
    });
    ok !$validator->validate({
        name => {
            first => 'foo',
            last  => 'bar',
            age   => '1.5',
        }
    });
};

subtest 'validation with $ref refereincing' => sub {
    my $validator = JSON::Schema::Validator->new({
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
    ok $validator->validate({
        name => { first => 'foo', last => 'bar' },
        age  => 12
    });
    ok !$validator->validate({
        name => { first => 'foo' },
        age  => 10,
    });
};

subtest 'validate with nested $ref referencing' => sub {
    my $validator = JSON::Schema::Validator->new({
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

    ok $validator->validate({
        person => {
            first   => 'ababa',
            last    => 'abebe',
            address => { code => 123, street => 'unadon' },
        },
    });

    ok !$validator->validate({
        person => {
            first   => 'a',
            last    => 'a',
            address => { code => 345.1, street => 'hamachi' },
        },
    });

    ok !$validator->validate({
        person => {
            first   => 'a',
            address => { code => 4, street => 'kegani' },
        },
    });
};

done_testing;
