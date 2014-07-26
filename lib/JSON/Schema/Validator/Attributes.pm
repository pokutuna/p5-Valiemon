package JSON::Schema::Validator::Attributes;
use strict;
use warnings;
use utf8;

use Class::Load qw(is_class_loaded try_load_class);

use Exporter::Lite;
our @EXPORT_OK = qw(attr);

sub attr {
    my ($name) = @_;
    my $class = join '::', __PACKAGE__, (ucfirst $name);
    return $class if is_class_loaded($class);

    my ($is_success) = try_load_class($class);
    return $is_success ? $class : undef;
}

1;
