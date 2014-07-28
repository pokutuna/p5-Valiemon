package JSON::Schema::Validator;
use 5.008001;
use strict;
use warnings;
use utf8;

use Carp qw(croak);
use JSON::Schema::Validator::Primitives;
use JSON::Schema::Validator::Context;
use JSON::Schema::Validator::Attributes qw(attr);

use Class::Accessor::Lite (
    ro => [qw(schema options pos)],
);

our $VERSION = "0.01";

sub new {
    my ($class, $schema, $options) = @_;

    # TODO should validate own schema
    if ($options->{validate_schema}) {}
    croak 'schema must be a hashref' unless ref $schema eq 'HASH';

    return bless {
        schema => $schema,
        options => $options,
    }, $class;
}

sub validate {
    my ($self, $data, $context) = @_;
    my $schema = $self->schema;

    $context //= JSON::Schema::Validator::Context->new($self, $schema);

    for my $key (keys %{$schema}) {
        my $attr = attr($key);
        if ($attr) {
            my ($is_valid, $error) = $attr->is_valid($context, $schema, $data);
            unless ($is_valid) {
                $context->push_error($error);
                next;
            }
        }
    }

    my $errors = $context->errors;
    my $is_valid = scalar @$errors ? 0 : 1;
    return wantarray ? ($is_valid, $errors->[0]) : $is_valid;
}

sub prims {
    my ($self) = @_;
    return $self->{prims} //= JSON::Schema::Validator::Primitives->new(
        $self->options
    );
}

1;

__END__

=encoding utf-8

=head1 NAME

JSON::Schema::Validator - It's new $module

=head1 SYNOPSIS

    use JSON::Schema::Validator;

=head1 DESCRIPTION

JSON::Schema::Validator is ...

=head1 LICENSE

Copyright (C) pokutuna.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

pokutuna E<lt>popopopopokutuna@gmail.comE<gt>

=cut
