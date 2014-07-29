use strict;
use warnings;

use Test::More;

use JSON::Schema::Validator;

use_ok 'JSON::Schema::Validator::Attributes::MinLength';

subtest 'validate minLength' => sub {
    my ($res, $err);
    my $v = JSON::Schema::Validator->new({ minLength => 6 });

    ($res, $err) = $v->validate('unagi');
    ok !$res;
    is $err->position, '/minLength';

    ($res, $err) = $v->validate('kegani');
    ok $res, 'maxLength is inclusive';
    is $err, undef;

    ($res, $err) = $v->validate('hamachi');
    ok $res;
    is $err, undef;
};

subtest 'detect schema error' => sub {
    {
        eval {
            JSON::Schema::Validator->new({ minLength => -1 })->validate('a');
        };
        like $@, qr/`minLength` must be/;
    }
    {
        eval {
            JSON::Schema::Validator->new({ minLength => {} })->validate('b');
        };
        like $@, qr/`minLength` must be/;
    }
};

done_testing;
