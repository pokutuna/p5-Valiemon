use strict;
use warnings;

use Test::More;

use JSON::Schema::Validator;

use_ok 'JSON::Schema::Validator::Attributes::Format';

subtest 'date-time' => sub {
    my ($res, $error);
    my $v = JSON::Schema::Validator->new({ format => 'date-time' });

    subtest 'UTC' => sub {
        ($res, $error) = $v->validate('2014-01-01T00:00:00Z');
        ok $res;
        is $error, undef;
    };

    subtest '+09:00' => sub {
        ($res, $error) = $v->validate('2014-01-01T00:00:00+09:00');
        ok $res;
        is $error, undef;
    };

    subtest 'not a String' => sub {
        ($res, $error) = $v->validate(undef);
        ok $res;
        is $error, undef;
    };

    subtest 'invalid' => sub {
        ($res, $error) = $v->validate('2014-01-01 00:00:00');
        ok !$res;
        is $error->position, '/format';
    };
};

subtest 'invalid format' => sub {
    my ($res, $error);

    my $v = JSON::Schema::Validator->new({ format => 'the-invalid-format' });
    eval {
        $v->validate('2014-01-01T00:00:00Z');
    };
    like $@, qr/invalid format: `the-invalid-format`/;
};

done_testing;
