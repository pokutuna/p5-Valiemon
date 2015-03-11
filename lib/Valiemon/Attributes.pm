package Valiemon::Attributes;
use strict;
use warnings;
use utf8;

use Carp qw(croak);
use Exporter qw(import);
use Class::Load qw(is_class_loaded try_load_class);

our @EXPORT_OK = qw(attr);

sub attr {
    my ($name, $schema_fragmnet) = @_;
    $name =~ s/^\$//; # TODO have package mappings instead of dinamic load
    my $class = join '::', __PACKAGE__, (ucfirst $name);
    return $class if is_class_loaded($class);

    my ($is_success) = try_load_class($class);
    return $is_success ? $class->new($schema_fragmnet) : undef;
}

sub attr_name {
    croak '`attr_name` method must be implemented';
}

sub new {
    my ($class, $schema_fragmnet) = @_;
    return bless {
        schema_fragmnet => $schema_fragmnet,
    }, $class;
}

sub schema_fragmnet { return $_[0]->{schema_fragmnet} }

sub is_valid {
    my ($self, $context, $schema, $data) = @_;
    croak '`is_valid` method must be implemented';
}

1;
