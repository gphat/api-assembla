use Test::More;
use strict;

use API::Assembla;

my $api = API::Assembla->new(
    username => 'iirobot',
    password => $ENV{'TEST_ASSEMBLA_PASS'}
);

my $data = $api->get_spaces;
cmp_ok('testinbeanstalk2g', 'eq', $data->{'third-level-domain'}, 'content');

done_testing;