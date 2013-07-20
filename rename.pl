#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use BatchFileRename;

sub usage
{
    print "-------------------------------------------------------------------------------------------------------------------\n";
    print "Summary: Renames all file in a given directory based on a source and destination schema\n\n";
    print "Schemas: You can specify a template value by surround a keyword with {{keyword}}.\n";
    print "\tOptionally, you can include an operation with a keyword in the source schema like {{keyword:x - 1}},\n";
    print "\tx always represent the variable you want to change.  In this case were are subtracting 1 from the keyword\n";
    print "\t(assuming it is a number).\n";
    print "\n";
    print "Usage: \n";
    print "\tsrc SOURCE         => a source schema\n";
    print "\tdst DESTINATION    => a destination schema\n";
    print "\tpath PATH          => the path to the folder of the file you want to rename\n";
    print "\tpretend            => set true if you just want to see what the files would be renamed to\n";
    print "\thelp               => display the help message\n";    
    print "\n";
    print "Example)\n";
    print "\t./rename.pl --src {{episode:x - 28}}.\\ {{name}}.xvid \\\n";
    print "\t            --dst BATMAN\\ The\\ Animated\\ Series\\ Complete\\ -\\ s01e{{episode}}\\ -\\ {{name}}.xvid \\\n";
    print "\t            --path /path/to/BATMAN\\ The\\ Animated\\ Series\\ Complete/Season\\ 1/\n";
    print "\t            --pretend\n";
    print "\n";

    exit(1);
}

# setup defaults
my $src = "";
my $dst = "";
my $path = "";
my $pretend;

my $result = GetOptions (   "src=s"     => \$src,
                            "dst=s"     => \$dst,
                            "path=s"    => \$path,
                            "pretend"   => \$pretend,
                            "help"      => sub{ usage(); }) || usage();


print $src."\n";
print $dst."\n";
print $path."\n";
#print $pretend."\n";

my $rename = BatchFileRename->new(  src     => $src,
                                    dst     => $dst,
                                    path    => $path,
                                    pretend => $pretend);


#my $rename = BatchFileRename->new(  src => '({EPISODE:x - 28}). ({NAME}).({EXTENSION})',
#                                    dst => 'BATMAN The Animated Series Complete - s01e({EPISODE}) - ({NAME}).({EXTENSION})',
#                                    path => '/path/to/files');

exit(0)
                                
