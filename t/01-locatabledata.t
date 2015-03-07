use strict;
use warnings;
use Test::More;

use Valiemon::LocatableData;

subtest 'new' => sub {
    my $data = Valiemon::LocatableData->new({ key => 'value' });
    isa_ok $data, 'Valiemon::LocatableData';
    is_deeply $data->raw, { key => 'value' };
    is_deeply $data->{positions}, [];
};

subtest 'types' => sub {
    my $hash = Valiemon::LocatableData->new({ key => 'value' });
    ok  $hash->is_hash;
    ok !$hash->is_array;
    ok !$hash->is_undef;

    my $array = Valiemon::LocatableData->new([0, 1, 2]);
    ok !$array->is_hash;
    ok  $array->is_array;
    ok !$array->is_undef;

    my $undef = Valiemon::LocatableData->new();
    ok !$undef->is_hash;
    ok !$undef->is_array;
    ok  $undef->is_undef;
};

subtest 'get' => sub {
    my $data = Valiemon::LocatableData->new({
        hash  => { key => 'value' },
        array => [1, 2, 3],
    });

    isa_ok $data->get('hash'), 'Valiemon::LocatableData';
    is_deeply $data->get('hash')->raw, { key => 'value' };
    is_deeply $data->get('hash')->{positions}, ['hash'];

    isa_ok $data->get('hash')->get('key'), 'Valiemon::LocatableData';
    is_deeply $data->get('hash')->get('key')->raw, 'value';
    is_deeply $data->get('hash')->get('key')->{positions}, ['hash', 'key'];

    isa_ok $data->get('array'), 'Valiemon::LocatableData';
    is_deeply $data->get('array')->raw, [1, 2, 3];
    is_deeply $data->get('array')->{positions}, ['array'];

    isa_ok $data->get('array'), 'Valiemon::LocatableData';
    is_deeply $data->get('array')->raw, [1, 2, 3];
    is_deeply $data->get('array')->{positions}, ['array'];

    isa_ok $data->get('array')->get(0), 'Valiemon::LocatableData';
    is_deeply $data->get('array')->get(0)->raw, 1;
    is_deeply $data->get('array')->get(0)->{positions}, ['array', '0'];

};

subtest 'pointer' => sub {

    subtest 'hash' => sub {
        my $hash = Valiemon::LocatableData->new({ key => 'value' });
        is $hash->pointer, '';
        is $hash->get('key')->pointer, '/key';
    };

    subtest 'array' => sub {
        my $array = Valiemon::LocatableData->new([1,2,3]);
        is $array->pointer, '';
        is $array->get('0')->pointer, '/0';
    };

    subtest 'nested' => sub {
        my $data = Valiemon::LocatableData->new({
            0    => 'hoge',
            ary  => [1,2,3,4,5],
            ''   => 'empty string key',
            hash => { key => 'value' },
            ' '  => { space => 'string' },
        });

        is $data->get('0')->pointer, '/0';
        is $data->get('ary')->pointer, '/ary';
        is $data->get('ary')->get(0)->pointer, '/ary/0';
        is $data->get('ary')->get(3)->pointer, '/ary/3';
        is $data->get('')->pointer, '/';
        is $data->get('hash')->get('key')->pointer, '/hash/key';
        is $data->get(' ')->pointer, '/ ';
        is $data->get(' ')->get('space')->pointer, '/ /space';
    };
};

done_testing;
