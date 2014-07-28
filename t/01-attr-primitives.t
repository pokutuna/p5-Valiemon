use strict;
use warnings;

use Test::More;

use JSON::Schema::Validator;

use_ok 'JSON::Schema::Validator::Primitives';

subtest 'is_object' => sub {
    my $p = JSON::Schema::Validator::Primitives->new;
    ok  $p->is_object({});
    ok !$p->is_object([]);
    ok !$p->is_object('hello');
    ok !$p->is_object(12.3);
    ok !$p->is_object(4);
    ok !$p->is_object(1);
    ok !$p->is_object(undef)
};

subtest 'is_array' => sub {
    my $p = JSON::Schema::Validator::Primitives->new;
    ok !$p->is_array({});
    ok  $p->is_array([]);
    ok !$p->is_array('hello');
    ok !$p->is_array(12.3);
    ok !$p->is_array(4);
    ok !$p->is_array(1);
    ok !$p->is_array(undef)
};

subtest 'is_string' => sub {
    my $p = JSON::Schema::Validator::Primitives->new;
    ok !$p->is_string({});
    ok !$p->is_string([]);
    ok  $p->is_string('hello');
    TODO :{
        local $TODO = 'weak typing !!';
        ok !$p->is_string(12.3);
        ok !$p->is_string(4);
        ok !$p->is_string(1);
    }
    ok !$p->is_string(undef)
};

subtest 'is_number' => sub {
    my $p = JSON::Schema::Validator::Primitives->new;
    ok !$p->is_number({});
    ok !$p->is_number([]);
    ok !$p->is_number('hello');
    ok  $p->is_number(12.3);
    ok  $p->is_number(4);
    TODO : {
        local $TODO = 'weak typing !!';
        ok !$p->is_number(1);
    }
    ok !$p->is_number(undef)
};

subtest 'is_integer' => sub {
    my $p = JSON::Schema::Validator::Primitives->new;
    ok !$p->is_integer({});
    ok !$p->is_integer([]);
    ok !$p->is_integer('hello');
    ok !$p->is_integer(12.3);
    ok  $p->is_integer(4);
    TODO : {
        local $TODO = 'weak typing !!';
        ok !$p->is_integer(1);
    }
    ok !$p->is_integer(undef)
};

subtest 'is_bool' => sub {
    my $p = JSON::Schema::Validator::Primitives->new;
    ok !$p->is_bool({});
    ok !$p->is_bool([]);
    ok !$p->is_bool('hello');
    ok !$p->is_bool(12.3);
    ok !$p->is_bool(4);
    ok  $p->is_bool(1);
    ok !$p->is_bool(undef);

    TODO : {
        local $TODO = 'invalidate 0.0';
        ok !$p->is_bool(0.0);
    }
};

subtest 'is_null' => sub {
    my $p = JSON::Schema::Validator::Primitives->new;
    ok !$p->is_null({});
    ok !$p->is_null([]);
    ok !$p->is_null('hello');
    ok !$p->is_null(12.3);
    ok !$p->is_null(4);
    ok !$p->is_null(1);
    ok  $p->is_null(undef);
};

done_testing;
