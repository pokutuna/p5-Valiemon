use strict;
use warnings;

use Test::More;

use Valiemon;

use_ok 'Valiemon::Attributes::AllOf';

subtest 'allOf' => sub {
    my ($res, $err);
    my $v = Valiemon->new({
        allOf => [
            { properties => { name => { type => "string" } }, required => ['name'] },
            { properties => { age => { type => "integer" } } },
        ],
    });

    ($res, $err) = $v->validate({ name => 'rei', age => 14 });
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate({ name => 'mari', age => 'secret' });
    ok !$res, 'failed second schema validation';
    is $err->position, '/allOf/1/properties/age/type';

    ($res, $err) = $v->validate({ age => 14 });
    ok !$res, 'failed first schema validation';
    is $err->position, '/allOf/0/required';

    ($res, $err) = $v->validate({ age => 'secret' });
    ok !$res, 'failed both schema validation';
    like $err->position, qr|^/allOf|;
};

subtest 'single element in allOf' => sub {
    my ($res, $err);
    my $v = Valiemon->new({
        allOf => [
            { properties => { age => { type => "integer" } } },
        ],
    });

    ($res, $err) = $v->validate({ name => 'rei', age => 14 });
    ok $res;
    is $err, undef;

    ($res, $err) = $v->validate({ name => 'mari', age => 'secret' });
    ok !$res;
    is $err->position, '/allOf/0/properties/age/type';
};

subtest 'detect schema error' => sub {
    {
        eval {
            Valiemon->new({
                allOf => {},
            })->validate([]);
        };
        like $@, qr/`allOf` must be/;
    }
    {
        eval {
            Valiemon->new({
                allOf => 'heyhey',
            })->validate([]);
        };
        like $@, qr/`allOf` must be/;
    }
};

done_testing;
