use strict;
use warnings;

use Test::More;

use JSON::Schema::Validator;

use_ok 'JSON::Schema::Validator::Attributes::Required';

subtest 'validate required' => sub {
    my ($res, $error);
    my $v = JSON::Schema::Validator->new({
        type => 'object',
        properties => {
            name => { type => 'string' },
            age  => { type => 'integer' },
        },
        required => [qw(name age)]
    });

    ($res, $error) = $v->validate({ name => 'oneetyan', age => 17 });
    ok $res;
    is $error, undef;

    ($res, $error) = $v->validate({ name => 'oneetyan', age => 17, is_kawaii => 1 });
    ok $res;
    is $error, undef;

    ($res, $error) = $v->validate({ name => 'oneetyan' });
    ok !$res;
    is $error->position, '/required';
};

subtest 'detect schema error' => sub {
    {
        eval {
            JSON::Schema::Validator->new({
                type => 'object',
                properties => { name => { type => 'string' } },
                required => [], # empty
            })->validate({ name => 'pom' });
        };
        like $@, qr/must be an array and have at leas one element/;
    }
    {
        eval {
            JSON::Schema::Validator->new({
                type => 'object',
                properties => { name => { type => 'string' } },
                required => { name => 1 }, # not array
            })->validate({ name => 'pom' });
        };
        like $@, qr/must be an array and have at leas one element/;
    }
};

done_testing;
