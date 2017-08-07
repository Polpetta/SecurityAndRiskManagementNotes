opendir(DIR, "./res/sections");
my @files = grep(/(.*EsLes.*|65-Exercise.tex)/,readdir(DIR));
closedir(DIR);

my $filename = './res/listOfSections.tex';
my $file;

unless(-e $filename) {
	#Create the file if it doesn't exist
	open $file, ">", $filename;
	close $file;
}

open $file, '>', $filename or die "Cannot open $filename: $!";

print $file "\\input{res/sections/01-Frontispiece.tex}\n";
print $file "\\input{res/sections/02-Colophon.tex}\n";
print $file "\\input{res/sections/06-Index.tex}\n";

foreach $f (@files) {
	print $file "\\input{res/sections/$f}\n";
}

print $file "\\input{res/sections/89-Answers.tex}";

close $file;