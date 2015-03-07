package Valiemon::LocatableData;
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

sub raw       { return $_[0]->{data} }
sub positions { return $_[0]->{positions} }

sub is_hash  { return ref $_[0]->raw eq 'HASH'  }
sub is_array { return ref $_[0]->raw eq 'ARRAY' }
sub is_undef { return !defined($_[0]->raw) }

sub pointer  {
    my ($self) = @_;
    return @{$self->{positions}} ? '/' . join '/', @{$self->{positions}} : '';
}

sub get {
    my ($self, $key_or_index) = @_;
    my $data = do {
        if ($self->is_hash) {
            $self->raw->{$key_or_index};
        } elsif ($self->is_array) {
            $self->raw->[$key_or_index];
        } elsif ($self->is_undef) {
            undef;
        } else {
            die 'TODO check';
        }
    };
    return __PACKAGE__->new($data, [@{$self->{positions}}, $key_or_index]);
}

# apply (current, index or key, self)
sub traverse {
    my ($self, $cb) = @_;

    if ($self->is_hash) {
        my $keys = keys %{$self->raw};
        $cb->($self->get($_), $_, $self) for @$keys;
    } elsif ($self->is_array) {
        my $size = @{$self->raw};
        $cb->($self->get($_), $_, $self) for (0..$size);
    } else {
        $cb->($self, undef, $self);
    }

    return;
}

1;
