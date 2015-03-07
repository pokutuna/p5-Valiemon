package Valiemon::Message;
use strict;
use warnings;
use utf8;

use Class::Accessor::Lite (
    ro => [qw(attribute pointer message)],
);

sub new {
    my ($class, $type, $attribute, $pointer, $message) = @_;
    return bless {
        type      => $type,
        attribute => $attribute,
        pointer   => $pointer,
        message   => $message,
    }, $class;
}

sub is_error   { return $_[0]->{type} eq 'error'   }
sub is_warning { return $_[0]->{type} eq 'warning' }

sub as_string {
    my ($self) = @_;
    my $message = $self->message || sprintf 'validation %s', $self->{type};
    return sprintf '[%s] %s at `%s` by `%s`',
        uc $self->{type}, $message, $self->pointer, $self->attribute->attr_name;
}

# TODO for compatibility
sub position { return $_[0]->pointer }

1;
