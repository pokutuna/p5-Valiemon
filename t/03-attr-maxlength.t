use strict;
use warnings;

use Test::More;

use JSON::Schema::Validator;

use_ok 'JSON::Schema::Validator::Attributes::MaxLength';

subtest 'validate maxLength' => sub {
    my ($res, $err);
    my $v = JSON::Schema::Validator->new({ maxLength => 6 });

    ($res, $err) = $v->validate('unagi');
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate('kegani');
    ok $res, 'maxLength is inclusive';
    is $err, undef;

    ($res, $err) = $v->validate('hamachi');
    ok !$res;
    is $err->position, '/maxLength';
};

subtest 'detect schema error' => sub {
    {
        eval {
            JSON::Schema::Validator->new({ maxLength => -1 })->validate('a');
        };
        like $@, qr/`maxLength` must be/;
    }
    {
        eval {
            JSON::Schema::Validator->new({ maxLength => {} })->validate('b');
        };
        like $@, qr/`maxLength` must be/;
    }
};

done_testing;
