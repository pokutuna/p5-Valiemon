use strict;
use warnings;

use Test::More;
use_ok 'Variemon::LocatableData';

subtest 'new' => sub {
    my $data = Variemon::LocatableData->new({ key => 'value' });
    isa_ok $data, 'Variemon::LocatableData';
    is_deeply $data->raw, { key => 'value' };
    is_deeply $data->{positions}, [];
};

subtest 'types' => sub {
    my $hash = Variemon::LocatableData->new({ key => 'value' });
    ok  $hash->is_hash;
    ok !$hash->is_array;
    ok !$hash->is_undef;

    my $array = Variemon::LocatableData->new([0, 1, 2]);
    ok !$array->is_hash;
    ok  $array->is_array;
    ok !$array->is_undef;

    my $undef = Variemon::LocatableData->new();
    ok !$undef->is_hash;
    ok !$undef->is_array;
    ok  $undef->is_undef;
};

subtest 'get' => sub {
    my $data = Variemon::LocatableData->new({
        hash  => { key => 'value' },
        array => [1, 2, 3],
    });

    isa_ok $data->get('hash'), 'Variemon::LocatableData';
    is_deeply $data->get('hash')->raw, { key => 'value' };
    is_deeply $data->get('hash')->{positions}, ['hash'];

    isa_ok $data->get('hash')->get('key'), 'Variemon::LocatableData';
    is_deeply $data->get('hash')->get('key')->raw, 'value';
    is_deeply $data->get('hash')->get('key')->{positions}, ['hash', 'key'];

    isa_ok $data->get('array'), 'Variemon::LocatableData';
    is_deeply $data->get('array')->raw, [1, 2, 3];
    is_deeply $data->get('array')->{positions}, ['array'];

    isa_ok $data->get('array'), 'Variemon::LocatableData';
    is_deeply $data->get('array')->raw, [1, 2, 3];
    is_deeply $data->get('array')->{positions}, ['array'];

    isa_ok $data->get('array')->get(0), 'Variemon::LocatableData';
    is_deeply $data->get('array')->get(0)->raw, 1;
    is_deeply $data->get('array')->get(0)->{positions}, ['array', '0'];

};

subtest 'pointer' => sub {
    my $hash = Variemon::LocatableData->new({ key => 'value' });
    is $hash->pointer, '';
    is $hash->get('key')->pointer, '/key';
};

done_testing;
