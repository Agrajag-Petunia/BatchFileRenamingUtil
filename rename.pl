#!/usr/bin/env perl

use strict;
use warnings;
use boolean;
use Getopt::Long;
use Config::Simple;
use FindBin;
use lib "$FindBin::Bin/";
use BatchFileRename;

Getopt::Long::config('bundling');

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
    print "\tinteractive        => set true if you just want to be prompted for input (useful if you're going to have a lot of spaces you need to backslash)\n";
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

sub config_shell
{
    my ($src, $dst, $path, $pretend);

    print "\nEnter the source template string:\n> ";
    chomp( $src = <STDIN> );

    print "\nEnter the destination template string:\n> ";
    chomp( $dst = <STDIN> );

    print "\nEnter the path to the files:\n> ";
    chomp( $path = <STDIN> );

    print "\nDo yo actually want to rename the files?(y/n)\n> ";
    chomp( my $tmp = <STDIN> );

    if ( $tmp =~/^y(?:es)?$/i )
    {
        $pretend = true;
    }

    return BatchFileRename->new( src     => $src,
                                 dst     => $dst,
                                 path    => $path,
                                 pretend => $pretend);
}

sub config_read
{
    my $file = shift;
    my %args = ();

    Config::Simple->import_from($file, \%args) || die ("Couldn't load config");

    return BatchFileRename->new( src     => $args{'default.src'},
                                 dst     => $args{'default.dst'},
                                 path    => $args{'default.path'},
                                 pretend => $args{'default.pretend'});
}

my ($rename, $src, $dst, $path, $pretend, $interactive, $config, $help);
GetOptions (   'src|s=s'        => \$src,
               'dst|d=s'        => \$dst,
               'path|p=s'       => \$path,
               'pretend|n'      => \$pretend,
               'interactive|i'  => \$interactive,
               'config|c=s'     => \$config,
               'help|h'         => sub{ usage(); }) || usage();


if ( $interactive )
{
    $rename = config_shell();
}

elsif ( $config )
{
    $rename = config_read($config);
}

elsif ( $src && $dst && $path )
{
    $rename = BatchFileRename->new( src     => $src,
                                    dst     => $dst,
                                    path    => $path,
                                    pretend => $pretend);
}

else
{
    usage();
}

$rename->batch_rename();

exit(0);   
