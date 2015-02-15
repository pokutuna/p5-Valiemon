package Variemon::LocatableData;
use strict;
use warnings;
use utf8;

sub new {
    my ($class, $data, $positions) = @_;
    return bless {
        data      => $data,
        positions => $positions // [],
    }, $class;
}

sub raw      { return $_[0]->{data} }
sub is_hash  { return ref $_[0]->raw eq 'HASH'  }
sub is_array { return ref $_[0]->raw eq 'ARRAY' }
sub is_undef { return !defined($_[0]->raw) }

sub pointer  {
    my ($self) = @_;
    return @{$self->{positions}} ? '/' . join '/', @{$self->{positions}} : '';
}

sub get {
    my ($self, $key_or_index) = @_;
    my $data =
        $self->is_hash ? $self->raw->{$key_or_index} : $self->raw->[$key_or_index];
    return __PACKAGE__->new($data, [@{$self->{positions}}, $key_or_index]);
}

1;
