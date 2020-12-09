#!/usr/bin/perl

my ($codebytes, $databytes, $recodebytes);
while (<>) {
    chomp;
    $codebytes += length;

    my $code = $_;
    s/\\\\/B/g;
    s/\\x[0-9a-f]{2}/H/g;
    s/\\"/Q/g;
    $bytes += length() - 2;

    $_ = $code;
    s/"/BQ/g;
    s/\\/BB/g;
    $recodebytes += length() + 2;
}

print $codebytes - $bytes, "\n", $recodebytes - $codebytes, "\n";
