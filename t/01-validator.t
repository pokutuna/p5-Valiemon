use strict;
use Test::More;
use JSON::XS;

use_ok 'JSON::Schema::Validator';

subtest 'validate type' => sub {
    my $validator = JSON::Schema::Validator->new({ type => 'object' });
    ok !$validator->validate('hello'), 'string is invalid';
    ok !$validator->validate([]), 'array is invalid';
    ok !$validator->validate(120), 'integer is invalid';
    ok !$validator->validate(5.5), 'number is invalid';
    ok !$validator->validate(undef), 'null is invalid';
    ok  $validator->validate({}), 'object is valid!';
};

done_testing;
