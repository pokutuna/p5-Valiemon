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
    # TODO boolean
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

done_testing;
