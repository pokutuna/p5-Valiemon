use strict;
use warnings;

use Test::More;

use JSON::Schema::Validator;

use_ok 'JSON::Schema::Validator::Attributes::Pattern';

subtest 'validate pattern' => sub {
    my ($res, $error);
    my $v = JSON::Schema::Validator->new({ pattern => '^[abc][def]?$' });

    ($res, $error) = $v->validate('a');
    ok $res;
    is $error, undef;

    ($res, $error) = $v->validate('ad');
    ok $res;
    is $error, undef;

    ($res, $error) = $v->validate(' a');
    ok !$res;
    is $error->position, '/pattern';

    ($res, $error) = $v->validate('ade');
    ok !$res;
    is $error->position, '/pattern';
};

subtest 'ignore pattern' => sub {
    my ($res, $error);
    my $v = JSON::Schema::Validator->new({ pattern => 'abc' });

    ($res, $error) = $v->validate({});
    ok $res, 'object isnt a string';
    is $error, undef;

    ($res, $error) = $v->validate([]);
    ok $res, 'array isnt a string';
    is $error, undef;

    ($res, $error) = $v->validate(undef);
    ok $res, 'null isnt a string';
    is $error, undef;

    TODO : {
        local $TODO = 'typing';

        ($res, $error) = $v->validate(1.5);
        ok $res, 'number isnt a string';
        is $error, undef;
    }
};

subtest 'detect schema error' => sub {
    {
        eval {
            JSON::Schema::Validator->new({
                type => 'string',
                pattern => [],
            })->validate('hoge');
        };
        like $@, qr/`pattern` must be a string/;
    }

    {
        eval {
            JSON::Schema::Validator->new({
                type => 'string',
                pattern => {},
            })->validate('fuga');
        };
        like $@, qr/`pattern` must be a string/;
    }
};


done_testing;
