use strict;
use warnings;

use Test::More;

use JSON::Schema::Validator;

use_ok 'JSON::Schema::Validator::Attributes::Properties';

subtest 'validate properties' => sub {
    my $v = JSON::Schema::Validator->new({
        type => 'object',
        properties => {
            name  => { type => 'string'  },
            price => { type => 'integer' },
        },
    });
    my ($res, $err);
    ($res, $err) = $v->validate({ name => 'fish', price => 300 });
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate({ name => 'meat', price => [] });
    ok !$res;
    is $err->position, '/properties/price/type';
};

subtest 'validate nested properties' => sub {
    my ($res, $err);
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

    ($res, $err) = $v->validate({
        name => {
            first => 'ane',
            last  => 'hosii',
            age   => 14,
        }
    });
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate({ name => [] });
    ok !$res;
    is $err->position, '/properties/name/type';

    ($res, $err) = $v->validate({
        name => {
            # none `first`
            last => 'hoge',
            age  => '18',
        }
    });
    ok $res, 'first is not required';
    is $err, undef;

    ($res, $err) = $v->validate({
        name => {
            first => 'foo',
            last  => 'bar',
            age   => '1.5',
        }
    });
    ok !$res;
    is $err->position, '/properties/name/properties/age/type';
};

done_testing;
