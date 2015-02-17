package Valiemon::Context;
use strict;
use warnings;
use utf8;

use Valiemon::ValidationError;

use Class::Accessor::Lite (
    ro => [qw(errors positions)],
);

sub new {
    my ($class, $validator, $schema) = @_;
    return bless {
        root_validator => $validator,
        errors         => [],
        positions      => [],
    }, $class;
}

sub con_validate { # TODO rename
    my ($self) = @_;
}

sub prims { $_[0]->{root_validator}->prims }

sub push_error {
    my ($self, $error) = @_;
    push @{$self->errors}, $error;
}

sub push_pos {
    my ($self, $pos) = @_;
    push @{$self->positions}, $pos;
}

sub pop_pos {
    my ($self) = @_;
    pop @{$self->positions};
}

sub position {
    my ($self) = @_;
    return '/' . join '/', @{$self->positions};
}

sub generate_error {
    my ($self, $attr) = @_;
    return Valiemon::ValidationError->new($attr, $self->position);
}

sub in_attr ($&) {
    my ($self, $attr, $code) = @_;
    $self->push_pos($attr->attr_name);
    my $is_valid = $code->();
    my @res = $is_valid ? (1, undef) : (0, $self->generate_error($attr));
    $self->pop_pos();
    return @res;
}

sub in ($&) {
    my ($self, $pos, $code) = @_;
    $self->push_pos($pos);
    my $res = $code->();
    $self->pop_pos();
    return $res;
}

sub sub_validator {
    my ($self, $sub_schema) = @_;
    require Valiemon;
    return Valiemon->new(
        $sub_schema,
        $self->{root_validator}->options, # inherit options
    );
}

1;
