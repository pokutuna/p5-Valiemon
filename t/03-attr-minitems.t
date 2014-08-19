use strict;
use warnings;

use Test::More;

use JSON::Schema::Validator;

use_ok 'JSON::Schema::Validator::Attributes::MinItems';

subtest 'minItems' => sub {
    my ($res, $err);
    my $v = JSON::Schema::Validator->new({
        type => 'array',
        minItems => 2,
    });

    ($res, $err) = $v->validate([1,2,3]);
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate([1,2]);
    ok $res, 'minItem is inclusive';
    is $err, undef;

    ($res, $err) = $v->validate([1]);
    ok !$res;
    is $err->position, '/minItems';
};

subtest 'detect schema error' => sub {
    {
        eval {
            JSON::Schema::Validator->new({ minItems => 3.14 })->validate([]);
        };
        like $@, qr/`minItems` must be/;
    }
    {
        eval {
            JSON::Schema::Validator->new({ minItems => {} })->validate([]);
        };
        like $@, qr/`minItems` must be/;
    }
};

done_testing;
