use strict;
use warnings;

use Test::More;

use Valiemon;

use_ok 'Valiemon::Attributes::MinProperties';

subtest 'minProperties' => sub {
    my ($res, $err);
    my $v = Valiemon->new({
        minProperties => 3,
    });

    ($res, $err) = $v->validate({
        message1 => 'hello',
        message2 => 'world',
        message3 => '!!',
        message4 => '!!!!!',
    });
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate({
        message1 => 'hello',
        message2 => 'world',
        message3 => '!!',
    });
    ok $res, 'minProperties is inclusive';
    is $err, undef;

    ($res, $err) = $v->validate({ message1 => 'hello', message2 => 'world' });
    ok !$res;
    is $err->position, '/minProperties';
};

subtest 'detect schema error' => sub {
    {
        eval {
            Valiemon->new({ minProperties => 3.14 })->validate({});
        };
        like $@, qr/`minProperties` must be/;
    }
    {
        eval {
            Valiemon->new({ minProperties => {} })->validate({});
        };
        like $@, qr/`minProperties` must be/;
    }
};

done_testing;
