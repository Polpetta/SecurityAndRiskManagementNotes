#!/usr/bin/perl

opendir(DIR, "./../res/sections");
my @files = grep(/.*EsLes.*/,readdir(DIR));
closedir(DIR);

my @quiz;
open my $fh, '>', "quiz.txt" or die "Cannot open output.txt: $!";

foreach $f (@files) {
	
	local $/ = undef;
	open FILE, ("../res/sections/" . $f) or die "Couldn't open file: $!";
	binmode FILE;
	my $y = <FILE>;
	close FILE;

	my @file = split(/\n/, $y);
	my $question = '';
	my $answer = '';
	my $answerNum = 1;
	my $pattern = 0;
	my $correct = '';
	my $question_break = 1;
	my $item = 0;

	for $line (@file) {
		if ($line =~ /\\Question/g) {
			if ($pattern eq 0) {
				$answerNum = 1;
				$question = $line;
				$question_break = 1;
			} else {
				$correct = $correct . ' ' . $line;
				$correct =~ s/\\Question//;
				$correct=~ s/^\s+//;
			}
		} elsif ($line =~ /\\begin\{(enumerate|itemize)\}/g) {
			$question =~ s/\\Question//;
			if ($question ne '') {
				$question = cleanForPrint($question);
				print $fh "Q: $question\n";
			}
			$question = '';
			$question_break = 0;
		} elsif ($line =~ /\\item/g) {
			if ($item eq 1) {
				$answer = cleanForPrint($answer);
				print $fh "$answerNum. $answer\n";
				$answer = '';
				$answerNum = $answerNum + 1;
			}
			$answer = $line;
			$answer =~ s/\\item//;
			$item = 1;
		} elsif ($question_break eq 1){
			$question = $question . ' ' . $line;
		} elsif ($line =~ /\\begin\{Answer\}/g) {
			$pattern = 1;
		} elsif ($line =~ /\\end\{Answer\}/g) {
			$correct =~ s/Risposta esatta: //;
			$correct = cleanForPrint($correct);
			print $fh "A: $correct\n";
			$correct = '';
			print $fh "E: explain...\n\n";
			$pattern = 0;
		} elsif ($line =~ /\\end\{(enumerate|itemize)\}/g){
			$item = 0;
			$answer = cleanForPrint($answer);
			print $fh "$answerNum. $answer\n";
			$answer = '';
		} elsif ($item eq 1) {
			$answer = $answer . ' ' . $line;
		}
	}
}

close($fh);

sub cleanForPrint() {
	my $text = $_[0];
	$text =~ s/^\s+//;
	$text =~ s/\\textit\{(.+)\}/$1/;
	return $text
}