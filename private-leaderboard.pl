#!/usr/bin/perl

# Paste your session cookie from your web browser here. If you use Chrome,
# load any adventofcode.com page with the network inspector open, find the
# `cookie` request header, and grab everything after `session=`. If you don't
# want to paste it here, you can set it in environment variable AOC_SESSION_ID
# instead.
my $session = '';

# Usage: private-leaderboard.pl <year> <leaderboard ID> [day] [star]
# (If you don't specify day and star, results will be printed for all of them.)

###########################################

use strict;
use LWP::UserAgent;
use JSON;
use utf8;
binmode STDOUT, ':encoding(UTF-8)';

my ($year, $lbid, $day, $star) = @ARGV;
defined($lbid) or die "Usage: $0 year leaderboard-id [day] [star]\n";
unless ($session) {
    if (exists $ENV{AOC_SESSION_ID}) {
        $session = $ENV{AOC_SESSION_ID};
    } else {
        die "Paste your session cookie into the top of this script first.\n";
    }
}
$day = sprintf("%02d", $day) if defined $day;

my $ua = LWP::UserAgent->new();
$ua->default_header(cookie => "session=${session}");
my $response = $ua->get("https://adventofcode.com/${year}/leaderboard/private/view/${lbid}.json");

die "Couldn't load leaderboard: " . $response->status_line unless ($response->is_success);

my $blob = JSON->new->utf8->decode($response->decoded_content);
my %players = %{$blob->{members}};
my %rawResults;
my %rankings;

for my $member (values %players) {
    my $id = $member->{id};
    while (my ($day, $star_time) = each %{$member->{completion_day_level}}) {
        for my $part (keys %$star_time) {
            my $key = sprintf '%02d-%1d', $day, $part;
            push @{$rawResults{$key}}, [$star_time->{$part}{get_star_ts}, $id];
        }
    }
}

my @sortOrder = map { $_->{id} } sort { $b->{local_score} <=> $a->{local_score} } values %players;

while (my ($key, $scores) = each %rawResults) {
    next if defined($day) and $key !~ /^$day/;
    next if defined($star) and $key !~ /-$star/;

    my @ranked = map { $_->[1] } sort { $a->[0] <=> $b->[0] } @$scores;
    $rankings{$key}{$ranked[$_]} = $_ + 1 for 0..$#ranked;

    @sortOrder = @ranked if defined $day and (defined $star or $key =~ /-2$/);
}

my ($namelen, @junk) = sort { $b <=> $a } map { length $_->{name} } values %players;
$namelen = 4 if $namelen < 4;

print "Name", " " x ($namelen - 3), join(" ", sort keys %rankings), "\n";
my $format = "%-${namelen}s " . "%4s " x (%rankings-1) . "%4s\n";
for my $id (@sortOrder) {
    my $name = $players{$id}{name};
    utf8::upgrade($name);
    printf $format, $name, map { $rankings{$_}{$id} or "-" } sort keys %rankings;
}
