use strict;
use warnings;

use Test::More;

use_ok 'Valiemon';

subtest 'validate' => sub {
    my $v = Valiemon->new({
        type => 'array',
        items => { type => 'integer' },
    });

    subtest 'pass' => sub {
        my ($result, $error) = $v->validate([1,2,3]);
        ok $result;
        ok ! $error;
    };

    subtest 'ValidationError has position, attribute, expected, actual' => sub {
        my ($result, $error) = $v->validate([1,2,'a']);
        ok !$result;
        isa_ok $error, 'Valiemon::ValidationError';
        is_deeply $error, {
            position => '/items/2/type',
            attribute => 'Valiemon::Attributes::Type',
            expected => {
                type => 'integer'
            },
            actual => 'a',
        };
    };
};

done_testing;
