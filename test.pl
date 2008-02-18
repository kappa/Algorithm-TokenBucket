#! /usr/bin/perl -w
use strict;

# $from-Id: bucket.t,v 1.1 2004/10/27 14:38:00 kappa Exp $

use Test::NoWarnings;
use Test::More tests => 25;

use Time::HiRes qw/sleep time/;

BEGIN { use_ok('Algorithm::TokenBucket'); }

my $bucket = new Algorithm::TokenBucket 25/1, 4;
isa_ok($bucket, 'Algorithm::TokenBucket');
is($bucket->{info_rate}, 25, 'info_rate init');
is($bucket->{burst_size}, 4, 'burst_size init');
ok(abs($bucket->{_last_check_time} - time) < 0.1, 'check_time init');
ok($bucket->{_tokens} < 0.01, 'tokens init');
sleep 0.3;
ok($bucket->conform(0), '0 conforms');
ok($bucket->conform(4), '4 conforms');
ok(!$bucket->conform(5), '5 does not conform');
$bucket->count(1);
ok(!$bucket->conform(4), '4 no more conforms');
ok($bucket->conform(3), 'only 3 does');
$bucket->count(1);
$bucket->count(1);
$bucket->count(1);
ok(!$bucket->conform(1), 'even 1 conforms no more');

# pass 50 within 2 seconds
my $traffic = 50;
my $time = time;
while (time - $time < 2) {
    if ($bucket->conform(1)) {
        $bucket->count(1);
        $traffic--;
    }
}
is($traffic, 0, '50 in 2 seconds');
my @state = $bucket->state;
is($state[0], 25, 'state[0]');
is($state[1], 4, 'state[1]');
ok(abs($state[3] - time) < 0.1, 'state[3]');

my $bucket1 = new Algorithm::TokenBucket @state;
isa_ok($bucket1, 'Algorithm::TokenBucket');
ok(!$bucket1->conform(1), 'restored bucket is almost empty');
sleep 0.1;
ok($bucket1->conform(2), 'restored bucket works');

is($bucket1->until(1), 0, 'no wait time for 1');
cmp_ok(my $t = $bucket1->until(500), '>=', 5, 'wait time');
cmp_ok(my $t2 = $bucket1->until(1000), '>=', $t, 'bigger wait time for a bigger number');
cmp_ok( ( ( $t2 - $t ) - ( 500 / 25 ) ), '<=', 1, 'until() is sort of accurate');

SKIP: {
	skip "no Storable", 1 unless eval { require Storable };

	my $bucket1_clone = Storable::thaw(Storable::freeze($bucket1));

	is_deeply(
		# allows for some error margin due to serialization
		[ map { (int($_ * 100)/100) } $bucket1->state ],
		[ map { (int($_ * 100)/100) } $bucket1_clone->state ],
		"state is the same"
	);
}
