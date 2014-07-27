package JSON::Schema::Validator;
use strict;
use warnings;
use utf8;

use Carp qw(croak);
use JSON::Schema::Validator::Primitives;
use JSON::Schema::Validator::Attributes qw(attr);

use Class::Accessor::Lite (
    ro => [qw(schema options)],
);

sub new {
    my ($class, $schema, $options) = @_;

    # TODO should validate own schema
    if ($options->{validate_schema}) {}
    croak 'schema must be a hashref' unless ref $schema eq 'HASH';

    my $ref = $schema->{'$ref'};
    return $class->new_from_ref($ref, $schema, $options) if $ref;

    return bless {
        schema => $schema,
        options => $options,
    }, $class;
}

sub new_from_ref {
    my ($class, $ref, $schema, $options) = @_;

    # TODO follow the standard dereferencing
    unless ($ref =~ qr|^#/|) {
        croak 'This package support only single scope and `#/` referencing';
    }

    # TODO use json pointer
    # TODO schema caching
    my $sub_schema = do {
        my $paths = do {
            my @p = split '/', $ref;
            [ splice @p, 1 ]; # remove '#'
        };
        my $root_validator = $options->{root_validator};
        my $root_schema = $root_validator ? $root_validator->schema : $schema;
        my $sub = $root_schema;
        {
            eval {
                while (@$paths) {
                    $sub = $sub->{shift @$paths};
                }
            };
            croak sprintf 'referencing schema `%s` not found', $ref if $@ || !$sub;
        }
        $sub;
    };

    return bless {
        schema  => $sub_schema,
        options => $options,
    };
}

sub root_validator {
    my ($self) = @_;
    return $self->options->{root_validator}
        ? $self->options->{root_validator} : $self;
}

sub validate {
    my ($self, $data) = @_;
    my $schema = $self->schema;
    my $errors = [];

    for my $key (keys %{$schema}) {
        my $attr = attr($key);
        if ($attr) {
            my $is_valid = $attr->is_valid($self, $schema, $data);
            unless ($is_valid) {
                push @$errors, $attr->generate_error($schema, $data);
                next unless $self->options->{collect_errors};
            }
        }
    }

    my $is_valid_all = scalar @$errors ? 0 : 1;
    return wantarray ? ($is_valid_all, $errors) : $is_valid_all;
}

sub prims {
    my ($self) = @_;
    return $self->{prims} //= JSON::Schema::Validator::Primitives->new(
        $self->options
    );
}

1;
