package BatchFileRename;

use strict;
use warnings;
use Template;
use Template::Extract;
use File::Slurp;
use Data::Dumper;

=head1 NAME

BatchFileRename - A class for renaming files based of template strings

=head1 SYNOPSIS
    use BatchFileRename;
    my $rename = BatchFileRename->new(src => $self->{src}, dst => $self->{dst}, path => $self->{path});
    $rename->refactor()  || die('Refactor failed: $!');
    
=head1 DESCRIPTION

This is a module to group rename files in a directory,
given a source and destination template
    
=head2 Methods

=head3 new
    my $rename = BatchFileRename->new(
                    src => $self->{src},
                    dst => $self->{dst},
                    path => $self->{path},
                    pretend => $self->{pretend});
    
    Instantiates a BatchFileRename object given an initial format template, a desired format template
    and the path to process in.
    
=cut

sub new
{
    my ($class, %args) = @_;
    
    my $self = bless({}, $class);
    
    #set up instance variables
    $self->{src} = $args{src};
    $self->{dst} = $args{dst};
    $self->{path} = $args{path};
    $self->{pretend} = $args{pretend};
    
    $self->__process_src();
    $self->__process_dst();
        
    return $self
}


=head3 

    $rename->batch_rename();
    
    This method runs the file rename on each file in the path

=cut
        
sub batch_rename
{
    my $self = shift;
    
    my @files = read_dir($self->{path});
    foreach my $file (@files)
    {
        my $new_name = $self->__rename($file);
        print $new_name."\n";

        if ( !$self->{pretend} )
        {
            rename($self->{path}.$file, $self->{path}.$new_name) ||
            die ('Error renaming file: orig='.$file.' new='.$new_name);
        }
    }
}


=head3 

    $self->__rename($filename);
    
    This method accepts the original filename and determines what it should be renamed to,
    which is returned as a string to batch_rename.

=cut

sub __rename
{
    my ($self, $filename) = @_;
    my $extractor = Template::Extract->new;
    my $injector = Template->new;
    my %operations = %{ $self->{operations} };
    my $output = $filename;

    #print 'Original filename: '.$filename."\n";    
    #print 'Source Template: '.$self->{src_template}."\n";
    #print 'Destination Template: '.$self->{dst_template}."\n";

    #extract the values from the original string using the src template
    my $values = $extractor->extract($self->{src_template}, $filename);
    
    #use Data::Dumper;
    #print Dumper($values)."\n";

    if ( $values )
    {
        my %vals = %$values;

        #apply any operations to the values
        foreach my $key (keys %operations)
        {
            $operations{ $key } =~ s/KEY/$vals{ $key }/g;
            #print $operations{ $key }."\n";
            $vals{ $key } = eval( $operations{ $key } );
        }

        #inject the extracted values into dst
        $output = '';
        $injector->process(\$self->{dst_template}, \%vals, \$output);
    }
        
    return $output;
}


=head3 

    $self->__process_src();
    
    This method extracts the template keyword and any operations for them from the src string.
    These are stored in this BatchFileRename's src_template and operations variables. 

=cut

sub __process_src
{
    my $self = shift;
    $self->{src_template} = $self->{src};
    
    my @keywords = $self->__extract_keywords($self->{src});
    my %operations = ();

    foreach my $keyword (@keywords)
    {
        #build up the proper Template string and a hash where
        #template keywords map to operations
        #print $keyword . "\n";
        
        my @parts = split(':', $keyword);
        #use Data::Dumper;
        #print Dumper(\@parts)."\n";   

        if (scalar(@parts) > 0)
        {
            #search and replace the keyword with the template key we want
            $self->{src_template} =~ s/\{\{\Q$keyword\E\}\}/\[\% \Q$parts[0]\E \%\]/g;
            #print $parts[0]."\n";

            if (scalar(@parts) > 1)
            {
                #joing the rest as our operation
                $operations{ $parts[0] } = join('', @parts[1 .. $#parts]);
            }
        }
    }
    
    $self->{'operations'} = \%operations;

    #use Data::Dumper;
    #print Dumper($self->{operations})."\n"; 
}


=head3 

    $self->__process_dst();
    
    This method simply converts the input syntax for dst into a template format.

=cut


sub __process_dst
{
    my $self = shift;
    $self->{dst_template} = $self->{dst};
    
    my @keywords = $self->__extract_keywords($self->{dst});

    foreach my $keyword (@keywords)
    {
        #simply build up the proper destination Template string
        #print $keyword . "\n";

        $self->{dst_template} =~ s/\{\{\Q$keyword\E\}\}/\[\% \Q$keyword\E \%\]/g;
    }
}


=head3 

    $self->__extract_keywords($str);
    
    This method extracts the delimited keywords/sections from the string and returns and array of them.

=cut

sub __extract_keywords
{
    my ($self, $str) = @_;

    my @keywords = ();
    my $keyword = '';

    while ($str =~ /\{\{(.*?)\}\}/g)
    {
        $keyword = $&;
        $keyword =~ s/^\{\{//;
        $keyword =~ s/\}\}$//;

        push(@keywords, $keyword);
    }

    return @keywords
}

1;

=head1 REPOSITORY

L<https://github.com/Agrajag-Petunia/ReFactor>

=head1 AUTHOR

Agrajag Petunia <agrajag.petunia@gmail.com>

=head1 LICENSE AND COPYRIGHT

This software is release under the MIT license cited below

=head2 The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


=head1 VERSION

0.01

=cut
