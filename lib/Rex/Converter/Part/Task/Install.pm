#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Rex::Converter::Part::Task::Install;

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

   my $data = [];

   my $install_type = $self->data->{type};
   my $klass = "Rex::Converter::Part::Task::Install::\u$install_type";
   eval "use $klass";
   if($@) {
      die("Invalid install type: $install_type.");
   }

   $self->data->children->each(sub {
      my ($data_elem) = @_;
      my $c = $klass->new(data => $data_elem);
      push(@{ $data }, { type => "\u$install_type", data => $c->parse });
   });

   return $data;
}

sub get {
   my ($self) = @_;

   my @ret = ();

   for my $elem (@{ $self->data }) {
      my $install_type = $elem->{type};

      my $klass = "Rex::Converter::Part::Task::Install::\u$install_type";
      eval "use $klass";
      if($@) {
         die("Invalid install type: $install_type.");
      }

      my $c = $klass->new(data => $elem->{data});
      push(@ret, $c->get);
   }

   return join("\n", @ret);
}

1;
