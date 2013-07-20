#!/usr/bin/env perl

use BatchFileRename;

my $rename = BatchFileRename->new(
                src => '({EPISODE:x - 28}). ({NAME}).({EXTENSION})',
                dst => 'BATMAN The Animated Series Complete - s01e({EPISODE}) - ({NAME}).({EXTENSION})',
                path => '/path/to/files');

exit(0)
                                
