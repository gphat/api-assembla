use Test::More;
use strict;

use API::Assembla;

my $api = API::Assembla->new(
    username => 'iirobot',
    password => $ENV{'TEST_ASSEMBLA_PASS'}
);

my $tickets = $api->get_tickets('dhHT8ENtKr4k_1eJe4gwI3');
cmp_ok(scalar(keys($tickets)), '==', 3, '3 tickets');

{
    my $ticket = $tickets->{4317338};

    cmp_ok($ticket->status_name, 'eq', 'New', 'status_name');
    ok($ticket->description =~ /make it/, 'description');
    cmp_ok($ticket->summary, 'eq', 'test ticketing', 'summary');
}

done_testing;