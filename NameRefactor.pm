package NameRefactor;

use strict;
use warnings;
use Template;
use Template::Extract;

=head1 NAME

NameRefactor - A class for renaming files based of template strings

=head1 SYNOPSIS
	use NameRefactor;
	my $nr = NameRefactor->new(src => $self->{src}, dst => $self->{dst}, path => $self->{path});
	$nr->refactor()  || die("Refactor failed: $!");
	
=head1 DESCRIPTION

This is a module to group rename files in a directory,
given a source and destination template
	
=head2 Methods

=head3 new
	my $nr = NameRefactor->new(src => $self->{src}, dst => $self->{dst}, path => $self->{path});
	
	Instantiates a NameRefactor object given an initial format template, a desired format template
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
	
	return $self;
}

=head3 refactor

	$nr->refactor();
	
	This method runs the file rename on each file in the path

=cut
		
sub refactor
{
	my $self = shift;
	
	#loop through files in directory
		#call reformat
}

sub reformat
{
	my ($self, $orig) = @_;
	my $extractor = Template::Extract->new;
	my $injector = Template->new;
	my $output = '';
	
	#extract the values from the original string using the src template
	my $values = $extractor->extract($self->src, $orig);
	
	#inject the extracted values into dst
	$injector->process(\$self->dst, $values, \$output);
	
	return $output;
}

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