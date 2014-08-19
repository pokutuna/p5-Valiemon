use strict;
use warnings;

use Test::More;

use JSON::Schema::Validator;

use_ok 'JSON::Schema::Validator::Attributes::MaxItems';

subtest 'minItems' => sub {
    my ($res, $err);
    my $v = JSON::Schema::Validator->new({
        type => 'array',
        maxItems => 4,
    });

    ($res, $err) = $v->validate([1,2,3]);
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate([1,2,3,4]);
    ok $res, 'maxItem is inclusive';
    is $err, undef;

    ($res, $err) = $v->validate([1,2,3,4,5]);
    ok !$res;
    is $err->position, '/maxItems';
};

subtest 'detect schema error' => sub {
    {
        eval {
            JSON::Schema::Validator->new({ maxItems => 3.14 })->validate([]);
        };
        like $@, qr/`maxItems` must be/;
    }
    {
        eval {
            JSON::Schema::Validator->new({ maxItems => {} })->validate([]);
        };
        like $@, qr/`maxItems` must be/;
    }
};

done_testing;
