requires 'perl', '5.012';

requires 'Class::Accessor::Lite';
requires 'Class::Load';
requires 'Clone';
requires 'JSON::PP';
requires 'JSON::XS';
requires 'List::MoreUtils';
requires 'Scalar::Util';
requires 'Types::Serialiser';
requires 'Test::Deep';
requires 'Data::Validate::URI';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

on 'develop' => sub {
    requires 'Software::License'
};
