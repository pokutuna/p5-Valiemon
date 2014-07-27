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
    # TODO schema caching
    my $sub_schema = do {
        my $paths = do {
            my @p = split '/', $ref;
            [ splice @p, 1 ];           # remove '#'
        };
        my $ss = $context->root_schema;
        {
            eval { $ss = $ss->{$_} for @$paths };
            croak sprintf 'referencing `%s` cause error', $ref if $@;
            croak sprintf 'schema `%s` not found', $ref unless $ss;
        }
        $ss;
    };

    $context->in_attr($class, sub {
        my $is_valid = JSON::Schema::Validator->new(
            $sub_schema,
            $context->rv->options,
        )->validate($data, $context);
        $is_valid;
    });

}
