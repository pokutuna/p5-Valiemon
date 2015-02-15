package Valiemon::SchemaObject;
use strict;
use warnings;
use utf8;

use parent 'Variemon::LocatableData';

use Carp qw(croak);

sub new {
    my ($class, $raw_schema, %opts) = @_;

    unless (ref $raw_schema eq 'HASH' || ref $raw_schema eq 'ARRAY') {
        croak 'schema must be a hashref or arrayref';
    }

    my $self = $class->SUPER::new(
        $raw_schema,
        $opts{schema_position},
    );
    $self->{schema_cache} = +{};
    $self->{root_schema}  = $opts{root_schema};

    return $self;
}

sub new_sub_schema {
    my ($self, $schema_data) = @_;
    return __PACKAGE__->new(
        $schema_data->raw,
        schema_position => $schema_data->{positions},
        root_schema     => $self->root_schema,
    );
}

sub is_root { return !defined $_[0]->{root_schema} }

sub root_schema {
    my ($self) = @_;
    return $self->is_root ? $self : $self->{root_schema};
}

sub prop {
    my ($self, $prop_name) = @_;
    return $self->get($prop_name)->raw;
}

sub sub_schema {
    my ($self, $key_or_index) = @_;
    my $schema_data = $self->get($key_or_index);
    croak "sub schema `$key_or_index` doesn't exist" if $schema_data->is_undef;
    return $self->new_sub_schema($schema_data);
}

## attribute utils

sub child_ref { return $_[0]->prop('$ref') }

sub get_default {
    my ($self) = @_;
    my $schema = $self->child_ref ? $self->resolve_ref($self->child_ref) : $self;
    return $schema->prop('default');
}


## cache

sub ref_schema_cache {
    my ($self, $ref_pointer, $sub_schema_data) = @_;
    croak 'only the root schema has cache' unless $self->is_root;
    return defined $sub_schema_data
        ? $self->{schema_cache}->{$ref_pointer} = $sub_schema_data # set
        : $self->{schema_cache}->{$ref_pointer};                   # get
}

sub resolve_ref {
    my ($self, $ref_pointer) = @_;

    # TODO follow the standard referencing
    unless ($ref_pointer =~ qr|^#/|) {
        croak 'This package support only single scope and `#/` referencing';
    }

    my $sub_schema_data = $self->root_schema->ref_schema_cache($ref_pointer) || do {
        my $paths = do {
            my @p = split '/', $ref_pointer;
            [ splice @p, 1 ]; # remove '#'
        };
        my $schema = $self->root_schema;
        {
            eval { $schema = $schema->get($_) for @$paths };
            croak sprintf 'referencing `%s` cause error', $ref_pointer if $@;
            croak sprintf 'schema `%s` not found', $ref_pointer if $schema->is_undef;
        }
        $self->root_schema->ref_schema_cache($ref_pointer, $schema); # set cache
        $schema;
    };
    return $self->new_sub_schema($sub_schema_data);
}

1;
