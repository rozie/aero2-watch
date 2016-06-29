#!/usr/bin/perl

use warnings;
use strict;

my @hosts=('google.com', 'facebook.com', 'wp.pl', 'onet.pl');		# host to check
my $sleeptime=15;							# how often perform test
my $longsleep=300;							# how long to wait after message
my $message='Network down. Time to enter CAPTCHA NOW!';			# message body
my $threshold=2;							# how many hosts needs to be up
my $messanger=`which xmessage`;						# get messanger program
my $debug=1;

chomp($messanger);
if (! $messanger){
	print "No valid messanger found, won't work!\n";
	exit 1;
}
else{
	print "Messanger is $messanger\n" if $debug;
}

while (1){
	my $upcount=0;
	
	# check all hosts
	foreach my $host (@hosts){ 
		if (host_icmp_alive($host)){
			$upcount++;
			print "$host is UP\n" if $debug;
		}
		else {
			print "$host is DOWN\n" if $debug;
		}
	}
	
	# display message
	if ($upcount < $threshold){
		print "UP host count below threshold!\n" if $debug;
		system (" $messanger $message ");
		sleep $longsleep;
	}
	# everything OK
	else {
		print "UP host above threshold...\n" if $debug;
	}
	sleep $sleeptime;
}

sub host_icmp_alive($) {
	my $retcode=0;					# fail by default
	my ($host) = @_;
	system(" ping -q -c 1 $host > /dev/null ");
	if (! $?){
		$retcode=1;				# host alive
	}
	return $retcode;
}
