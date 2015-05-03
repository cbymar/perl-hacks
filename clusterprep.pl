#!/usr/bin/perl -w

#This program reads through a file, reading individual segments listed in each line
#then adds them to a deduped array of possible segments
#then, on second pass through the file, it prints an indicator variable for presence of each segment on each line.

$filein = 'ftalpha.txt';
$fileout = 'writeout.txt';

open(FILE, $filein) or die "Can't open ftalpha.txt: $!";

%mastersegs = (); #initialize master list of segments;
$, = ",";
while ($line = <FILE>) {
	chomp($line);
	@segs = (); #initialize segs
	my @columns = split("\t",$line);
	$segread = $columns[11];
	@segs = split(";",$segread);
	foreach $seg (@segs) {
		if ($seg =~ /ksg\=/) {
			$seg =~ s/ksg\=//;
			$mastersegs{$seg} = 1;
		}
	}
}
@keyarray = sort { $a cmp $b } keys %mastersegs;
open(OUTPUT_FILE, ">$fileout");
#give output file a header row;
print OUTPUT_FILE "Line_number,";
print OUTPUT_FILE @keyarray;
print OUTPUT_FILE "\n";
$indicators = scalar(@keyarray);
open(FILEAGAIN, $filein) or die "Can't open ftalpha.txt: $!";
while ($lineagain = <FILEAGAIN>) {
	chomp($lineagain);
	print OUTPUT_FILE $. . ",";
	my $i = 0;
	foreach $keyseg (@keyarray) {
		$i++;
		if ($lineagain =~ /$keyseg/) {
			print OUTPUT_FILE "1";
		}
		else {
			print OUTPUT_FILE "0";
		}
		print OUTPUT_FILE "," unless $i == $indicators;
	}
	print OUTPUT_FILE "\n";
}

close(FILEAGAIN);
close(OUTPUT_FILE);

