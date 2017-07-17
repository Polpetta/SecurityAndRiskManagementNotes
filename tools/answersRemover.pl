#!/usr/bin/perl -w

opendir(DIR, "./../res/sections");
my @files = grep(/.*EsLes.*/,readdir(DIR));
closedir(DIR);

my @answers;

foreach $f (@files) {
	
	local $/ = undef;
	open FILE, ("../res/sections/" . $f) or die "Couldn't open file: $!";
	binmode FILE;
	my $y = <FILE>;
	close FILE;

	my @file = split(/\n/, $y);
	my @new_file;
	my $pattern = 0;

	for $line (@file) {
		if ($line =~ /\\begin\{Answer\}/g) {
			$pattern = 1;
		}
		if ($pattern eq 0) {
			push @new_file, $line;
		} else {
			push @answers, $line;
		}
		if ($line =~ /\\end\{Answer\}/g) {
			$pattern = 0;
		}
	}

	open my $fh, '>', ("../res/sections/".$f) or die "Cannot open output.txt: $!";
	foreach (@new_file) {
		print $fh "$_\n"; # Print each entry in our new array to the file
	}
	close($fh);
}

open my $fh, '>', "../res/sections/89-Answers.tex" or die "Cannot open output.txt: $!";
print $fh "\\chapter{Soluzioni}\n";
foreach (@answers) {
	print $fh "$_\n"; # Print each entry in our new array to the file
}
close($fh);