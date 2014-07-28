requires 'perl', '5.008001';

requires 'Class::Accessor::Lite';
requires 'Class::Load';
requires 'JSON::XS';
requires 'List::MoreUtils';
requires 'Scalar::Util';
requires 'Types::Serialiser';

on 'test' => sub {
    requires 'Test::More', '0.98';
};
