use strict;
use warnings;

use Test::More;

use Variemon;

use_ok 'Variemon::Context';

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
    my $v = Variemon->new($schema);
    my $c = Variemon::Context->new($v, $v->schema);
    is $c->root_validator, $v;
};

subtest 'sub_validator' => sub {
    my $opts = { use_json_boolean => 1 };
    my $v = Variemon->new($schema, $opts);
    is_deeply $v->options, $opts;

    my $c = Variemon::Context->new($v, $v->schema);
    my $sub_schema = $v->schema->resolve_ref('#/definitions/person');
    my $sv = $c->sub_validator($sub_schema);
    is_deeply $sv->options, $opts, 'inherit options from root validator in context';
};

done_testing;
