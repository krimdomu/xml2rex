#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Rex::Converter::Part::Group;

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

sub parse {
   my ($self) = @_;

   my $data = {
      name   => $self->data->attrs("name"),
      server => [],
   };

   $self->data->children->each(sub {
      my ($server_tag) = @_;
      push(@{ $data->{server} }, $server_tag->attrs("name"));   
   });

   return $data;
}

sub get { 
   my ($self) = @_;
   return template('@group.part', %{ $self->data });
}


1;

__DATA__

@group.part
group "<%= $::name %>" => "<%= join('","', @{ $::server }) %>";
@end
