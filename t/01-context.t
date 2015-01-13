use strict;
use warnings;

use Test::More;

use JSON::Schema::Validator;

use_ok 'JSON::Schema::Validator::Context';

my $schema = {
    type => 'object',
    definitions => {
        person => {
            type => 'object',
            properties => {
                name => { type => 'string' },
                child => { '$ref' => '#/definitions/person' },
            },
            required => [qw(name)],
        },
    },
    properties => {
        user => { '$ref' => '#/definitions/person' },
    },
};

subtest 'new' => sub {
    my $v = JSON::Schema::Validator->new($schema);
    my $c = JSON::Schema::Validator::Context->new($v, $v->schema);
    is $c->root_validator, $v;
    is_deeply $c->root_schema, $v->schema;
};

subtest 'sub_validator' => sub {
    my $opts = { use_json_boolean => 1 };
    my $v = JSON::Schema::Validator->new($schema, $opts);
    is_deeply $v->options, $opts;

    my $c = JSON::Schema::Validator::Context->new($v, $v->schema);
    my $sub_schema = $v->resolve_ref('#/definitions/person');
    my $sv = $c->sub_validator($sub_schema);
    is_deeply $sv->options, $opts, 'inherit options from root validator in context';
};

done_testing;
