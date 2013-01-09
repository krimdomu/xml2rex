#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Rex::Converter::Part::Base;

use strict;
use warnings;

use Rex::Commands::File;

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   return $self;
}


sub data { return shift->{data}; }

sub parse {
   my ($self) = @_;

   my $data = $self->data->attrs;

   return $data;
}

sub get { return ""; }

1;
