package Valiemon::ValidationError;
use strict;
use warnings;
use utf8;

use Class::Accessor::Lite (
    ro => [qw(attribute position)],
);

sub new {
    my ($class, $attr, $position) = @_;
    return bless {
        attribute => $attr,
        position  => $position,
    }, $class;
}

sub as_message {
    my ($self) = @_;
    return sprintf 'invalid `%s` at `%s`.',
        $self->attribute->attr_name, $self->position;
}

1;
