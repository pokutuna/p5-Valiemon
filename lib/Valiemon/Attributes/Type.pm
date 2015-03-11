package Valiemon::Attributes::Type;
use strict;
use warnings;
use utf8;
use parent qw(Valiemon::Attributes);

use List::MoreUtils qw(any);

sub attr_name { 'type' }

sub is_valid {
    my ($self, $context, $schema, $data) = @_;
    $context->in_attr($self, sub {
        my $types = $schema->prop('type');

        my $is_valid = do {
            if (ref $types eq 'ARRAY') {
                any { $self->_check($context->prims, $_, $data) } @$types
            } else {
                $self->_check($context->prims, $types, $data);
            }
        };
        $is_valid;
    });
}

sub _check {
    my ($class, $prims, $type, $data) = @_;
    my $method = 'is_' . $type;
    $prims->can($method) && $prims->$method($data) ? 1 : 0;
}

1;
