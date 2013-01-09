#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Rex::Converter::Part::Task::Mkdir;

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

sub get {
   my ($self) = @_;
   return template('@mkdir.part', %{ $self->data });
}

1;


__DATA__

@mkdir.part
   mkdir "<%= $::path %>",
      <% if(defined $::owner) { %>owner => "<%= $::owner %>",<% } -%>
      <% if(defined $::group) { %>group => "<%= $::group %>",<% } -%>
      <% if(defined $::mode)  { %>mode  => "<%= $::mode %>"<% } -%>;
@end
