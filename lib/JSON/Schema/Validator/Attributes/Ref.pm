package JSON::Schema::Validator::Attributes::Ref;
use strict;
use warnings;
use utf8;
use parent qw(JSON::Schema::Validator::Attributes);

use Carp qw(croak);

sub attr_name { '$ref' }

sub is_valid {
    my ($class, $context, $schema, $data) = @_;
    my $ref = $schema->{'$ref'};

    # TODO follow the standard dereferencing
    unless ($ref =~ qr|^#/|) {
        croak 'This package support only single scope and `#/` referencing';
    }

    # TODO use json pointer
    my $sub_schema = $context->rv->ref_schema_cache($ref) || do {
        my $paths = do {
            my @p = split '/', $ref;
            [ splice @p, 1 ]; # remove '#'
        };
        my $ss = $context->root_schema;
        {
            eval { $ss = $ss->{$_} for @$paths };
            croak sprintf 'referencing `%s` cause error', $ref if $@;
            croak sprintf 'schema `%s` not found', $ref unless $ss;
        }
        $context->rv->ref_schema_cache($ref, $ss); # caching
        $ss;
    };

    $context->in_attr($class, sub {
        $context->sub_validator($sub_schema)->validate($data, $context);
    });
}

1;
