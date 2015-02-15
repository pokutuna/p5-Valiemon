package Valiemon::SchemaObject;
use strict;
use warnings;
use utf8;

use Carp qw(croak);
use Class::Accessor::Lite (
    ro => [qw(raw)],
);

sub new {
    my ($class, $raw_schema, $root_schema) = @_;

    unless (ref $raw_schema eq 'HASH' || ref $raw_schema eq 'ARRAY') {
        croak 'schema must be a hashref or arrayref';
    }

    return bless {
        raw          => $raw_schema, # hashref, array
        schema_cache => +{},
        root_schema  => $root_schema,
    }, $class
}

sub is_root  { return !defined $_[0]->{root_schema} }
sub is_hash  { return ref $_[0]->raw eq 'HASH'  }
sub is_array { return ref $_[0]->raw eq 'ARRAY' }

sub root_schema {
    my ($self) = @_;
    return $self->is_root ? $self : $self->{root_schema};
}

sub prop {
    my ($self, $prop_name) = @_;
    return $self->raw->{$prop_name};
}

sub sub_schema {
    my ($self, $key_or_index) = @_;
    my $sub_schema_raw = $self->is_hash
        ? $self->raw->{$key_or_index} : $self->raw->[$key_or_index];
    croak "sub schema `$key_or_index` doesn't exist" unless defined $sub_schema_raw;
    return $self->_create_sub_schema($sub_schema_raw);
}

sub _create_sub_schema {
    my ($self, $raw_schema) = @_;
    return __PACKAGE__->new($raw_schema, $self->root_schema);
}


## attribute utils

sub child_ref { return $_[0]->prop('$ref') }

sub get_default {
    my ($self) = @_;
    my $schema = $self->child_ref ? $self->resolve_ref($self->child_ref) : $self;
    return $schema->prop('default');
}


## cache

# cache hashref instead of SchemaObject for avoiding circular reference
sub ref_schema_cache {
    my ($self, $ref_pointer, $sub_schema_raw) = @_;
    croak 'only the root schema has cache' unless $self->is_root;
    return defined $sub_schema_raw
        ? $self->{schema_cache}->{$ref_pointer} = $sub_schema_raw
        : $self->{schema_cache}->{$ref_pointer};
}

sub resolve_ref {
    my ($self, $ref_pointer) = @_;

    # TODO follow the standard referencing
    unless ($ref_pointer =~ qr|^#/|) {
        croak 'This package support only single scope and `#/` referencing';
    }

    my $root = $self->root_schema;
    my $sub_schema_raw = $root->ref_schema_cache($ref_pointer) || do {
        my $paths = do {
            my @p = split '/', $ref_pointer;
            [ splice @p, 1 ]; # remove '#'
        };
        my $schema = $root->raw;
        {
            eval { $schema = $schema->{$_} for @$paths };
            croak sprintf 'referencing `%s` cause error', $ref_pointer if $@;
            croak sprintf 'schema `%s` not found', $ref_pointer unless $schema;
        }
        $root->ref_schema_cache($ref_pointer, $schema);
        $schema;
    };
    return $self->_create_sub_schema($sub_schema_raw);
}

1;
