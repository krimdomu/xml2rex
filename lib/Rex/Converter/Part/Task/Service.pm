#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Rex::Converter::Part::Task::Service;

use strict;
use warnings;

use Rex::Converter::Part::Base;
use Rex::Template;
use Rex::Commands::File;
use Data::Dumper;

use base qw(Rex::Converter::Part::Base);

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = $proto->SUPER::new(@_);

   bless($self, $proto);

   return $self;
}

sub get {
   my ($self) = @_;
   return template('@service.part', %{ $self->data });
}

1;

__DATA__

@service.part
   service "<%= $::name %>" => "<%= $::action %>";
@end
