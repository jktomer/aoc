#!/usr/bin/perl

my %form, $groupsize;
my ($ortotal, $andtotal);
while (<>) {
    chomp;
    if ($_ eq "") {
        $ortotal += scalar keys %form;
        map { $andtotal++ if $form{$_} == $groupsize } keys %form;
        %form = ();
        $groupsize = 0;
        next;
    }
    $groupsize++;
    $form{$_}++ for (split(//));
}

$ortotal += scalar keys %form;
map { $andtotal++ if $form{$_} == $groupsize } keys %form;

print "$ortotal $andtotal\n";
