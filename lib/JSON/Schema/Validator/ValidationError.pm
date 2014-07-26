package JSON::Schema::Validator::ValidationError;
use strict;
use warnings;
use utf8;

sub new {
    my ($class, $schema, $data, $attr_name) = @_;
    return bless {
        schema    => $schema,
        data      => $data,
        attribute => $attr_name,
    }, $class;
}

1;
