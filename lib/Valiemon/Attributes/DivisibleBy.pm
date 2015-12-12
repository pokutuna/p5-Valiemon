package Valiemon::Attributes::DivisibleBy;
use strict;
use warnings;
use utf8;

use parent qw(Valiemon::Attributes::MultipleOf);

sub attr_name { 'divisibleBy' };

# divisibleBy was renamed to multipleOf.

1;
