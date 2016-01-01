use strict;
use warnings;

use Test::More;

use Valiemon;

use_ok 'Valiemon::Attributes::Dependencies';

subtest 'validate dependencies with property set' => sub {
    my ($res, $error);
    my $v = Valiemon->new({
        dependencies => {
            has_cv => ['cv_actor'],
        },
    });

    ($res, $error) = $v->validate({ name => 'eve' });
    ok $res, 'ok when depending property not exists';
    is $error, undef;

    ($res, $error) = $v->validate({ name => 'uzuki', has_cv => 1, cv_actor => 'hashy' });
    ok $res, 'ok when both depending and dependent properties are present';
    is $error, undef;

    ($res, $error) = $v->validate({ name => 'asuka', has_cv => 1, cv_actor => [] });
    ok $res, 'any type ok';
    is $error, undef;

    ($res, $error) = $v->validate({ name => 'asuka', has_cv => 1 });
    ok !$res, 'ng when depending property exists but dependent property not';
    is $error->position, '/dependencies';
};

subtest 'validate dependencies with subschema' => sub {
    my ($res, $error);
    my $v = Valiemon->new({
        dependencies => {
            has_cv => {
                properties => {
                    cv_actor => { type => "string" },
                },
            },
        },
    });

    ($res, $error) = $v->validate({ name => 'eve' });
    ok $res, 'ok when depending property not exists';
    is $error, undef;

    ($res, $error) = $v->validate({ name => 'uzuki', has_cv => 1, cv_actor => 'hashy' });
    ok $res, 'ok when both depending and dependent properties are present';
    is $error, undef;

    ($res, $error) = $v->validate({ name => 'asuka', has_cv => 1, cv_actor => [] });
    ok !$res, q|ng when dependent property doesn't match sub schema|;
    is $error->position, '/dependencies';
};

subtest 'detect schema error' => sub {
    {
        eval {
            Valiemon->new({
                type => 'object',
                properties => { name => { type => 'string' } },
                dependencies => [], # Not object
            })->validate({ name => 'pom' });
        };
        like $@, qr/be an object/;
    }
    {
        eval {
            Valiemon->new({
                type => 'object',
                properties => { name => { type => 'string' } },
                dependencies => { name => 1 }, # not array
            })->validate({ name => 'pom' });
        };
        like $@, qr/ member values can no longer be single strings/;
    }
    {
        eval {
            Valiemon->new({
                type => 'object',
                properties => { name => { type => 'string' } },
                dependencies => { name => [ 'foo', [], 'bar' ] }, # not string
            })->validate({ name => 'pom' });
        };
        like $@, qr/ be a string/;
    }
    {
        eval {
            Valiemon->new({
                type => 'object',
                properties => { name => { type => 'string' } },
                dependencies => { name => [ 'foo', 'foo', 'bar' ] }, # not unique
            })->validate({ name => 'pom' });
        };
        like $@, qr/ be unique/;
    }
    {
        eval {
            Valiemon->new({
                type => 'object',
                properties => { name => { type => 'string' } },
                dependencies => { name => [] }, # empty
            })->validate({ name => 'pom' });
        };
        like $@, qr/ have at least one element/;
    }
};

done_testing;
