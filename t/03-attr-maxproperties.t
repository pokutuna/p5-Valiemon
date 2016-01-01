use strict;
use warnings;

use Test::More;

use Valiemon;

use_ok 'Valiemon::Attributes::MaxProperties';

subtest 'maxProperties' => sub {
    my ($res, $err);
    my $v = Valiemon->new({
        maxProperties => 3,
    });

    ($res, $err) = $v->validate({ message1 => 'hello', message2 => 'world' });
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate({
        message1 => 'hello',
        message2 => 'world',
        message3 => '!!',
    });
    ok $res, 'maxProperties is inclusive';
    is $err, undef;

    ($res, $err) = $v->validate({
        message1 => 'hello',
        message2 => 'world',
        message3 => '!!',
        message4 => '!!!!!',
    });
    ok !$res;
    is $err->position, '/maxProperties';
};

subtest 'detect schema error' => sub {
    {
        eval {
            Valiemon->new({ maxProperties => 3.14 })->validate({});
        };
        like $@, qr/`maxProperties` must be/;
    }
    {
        eval {
            Valiemon->new({ maxProperties => {} })->validate({});
        };
        like $@, qr/`maxProperties` must be/;
    }
};

done_testing;
