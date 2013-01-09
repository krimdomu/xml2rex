#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Rex::Converter::Part::Task::Install::Package;

use strict;
use warnings;

use Rex::Converter::Part::Base;
use Rex::Template;
use Rex::Commands::File;

use base qw(Rex::Converter::Part::Base);

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = $proto->SUPER::new(@_);

   bless($self, $proto);

   return $self;
}

sub parse {
   my ($self) = @_;

   my $data = {
      name => $self->data->attrs("name"),
      version => ($self->data->attrs("version") || undef),
   };

   return $data;
}

sub get { 
   my ($self) = @_;
   return template('@package.part', %{ $self->data });
}

1;

__DATA__

@package.part
<% if($::version) { %>
   install package => "<%= $::name %>",
           version => "<%= $::version %>";<% } else { -%>
   install package => "<%= $::name %>";<% } -%>
@end
