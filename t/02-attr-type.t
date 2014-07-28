use strict;
use warnings;

use Test::More;

use JSON::Schema::Validator;

use_ok 'JSON::Schema::Validator::Attributes::Type';

subtest 'validate type object' => sub {
    my ($res, $err);
    my $v = JSON::Schema::Validator->new({ type => 'object' });
    ($res, $err) = $v->validate({});
    ok $res, 'object is valid!';
    is $err, undef;

    ($res, $err) = $v->validate('hello');
    ok !$res, 'string is invalid';
    is $err->position, '/type';

    ($res, $err) = $v->validate([]);
    ok !$res, 'array is invalid';
    is $err->position, '/type';

    ($res, $err) = $v->validate(120);
    ok !$res, 'integer is invalid';
    is $err->position, '/type';

    ($res, $err) = $v->validate(5.5);
    ok !$res, 'number is invalid';
    is $err->position, '/type';

    ($res, $err) = $v->validate(undef);
    ok !$res, 'null is invalid';
    is $err->position, '/type';

    ($res, $err) = $v->validate(1);
    ok !$res, 'boolean is invalid';
    is $err->position, '/type';
};

done_testing;
