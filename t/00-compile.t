use strict;
use Test::More;

use_ok $_ for qw(
    Valiemon
    Valiemon::Primitives
    Valiemon::Context
    Valiemon::LocatableData
    Valiemon::Attributes::Items
    Valiemon::Attributes::Properties
    Valiemon::Attributes::Ref
    Valiemon::Attributes::Required
    Valiemon::Attributes::Type
    Valiemon::Attributes::AdditionalProperties
    Valiemon::Attributes::Enum
    Valiemon::Attributes::Format
    Valiemon::Attributes::Maximum
    Valiemon::Attributes::MaxItems
    Valiemon::Attributes::MaxLength
    Valiemon::Attributes::Minimum
    Valiemon::Attributes::MinItems
    Valiemon::Attributes::MinLength
    Valiemon::Attributes::Pattern
);

done_testing;
