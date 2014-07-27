package JSON::Schema::Validator;
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

sub new {
    my ($class, $schema, $options) = @_;

    # TODO should validate own schema
    if ($options->{validate_schema}) {}
    croak 'schema must be a hashref' unless ref $schema eq 'HASH';

    return bless {
        pos => $options->{pos} || '#/', # TODO
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
                next; # TODO impliment option like: $self->options->{collect_errors};
            }
        }
    }

    my $errors = $context->errors;
    my $is_valid_all = scalar @$errors ? 0 : 1;

    # debugging
    if ($context->is_root && !$is_valid_all) {
        use Data::Dumper; warn Dumper $errors->[0]->as_message ;
    }

    return wantarray ? ($is_valid_all, $errors) : $is_valid_all;
}

sub prims {
    my ($self) = @_;
    return $self->{prims} //= JSON::Schema::Validator::Primitives->new(
        $self->options
    );
}

1;
