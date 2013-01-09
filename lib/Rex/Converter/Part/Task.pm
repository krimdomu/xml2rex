#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Rex::Converter::Part::Task;

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
      name => $self->data->attrs("name"),
      group => $self->data->attrs("group") || undef,
      order => [],
   };

   $self->data->children->each(sub {
      my ($order_elem) = @_;
      my $order_type = $order_elem->type;

      my $klass = "Rex::Converter::Part::Task::\u$order_type"; 
      eval "use $klass";
      if($@) {
         die("Invalid task order: $order_type.");
      }

      my $c = $klass->new(data => $order_elem);
      push(@{ $data->{order} }, { type => "\u$order_type", data => $c->parse });

   });

   return $data;
}

sub get { 
   my ($self) = @_;

   my @orders = ();

   for my $order (@{ $self->data->{order} }) {
      my $order_type = $order->{type};

      my $klass = "Rex::Converter::Part::Task::\u$order_type"; 
      eval "use $klass";
      if($@) {
         die("Invalid task order: $order_type.");
      }

      my $c = $klass->new(data => $order->{data});
      push(@orders, $c->get);
   }

   return template('@task.part', %{ $self->data }, order => join("\n", @orders));
}

1;


__DATA__

@task.part
<% if(! $::group) { %>
task "<%= $::name %>", sub {
<% } else { %>
task "<%= $::name %>", group => "<%= $::group %>", sub {
<% } %>
<%= $::order %>
};
@end
