#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Rex::Converter::Base;

use strict;
use warnings;

use Data::Dumper;
use Rex::Converter::Part::Auth;

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   return $self;
}

sub convert {
   my ($self, $data) = @_;

   my $s = "";

   for my $order (@{ $data }) {
      my $order_type = $order->{type};

      my $klass = "Rex::Converter::Part::$order_type";
      eval "use $klass";
      if($@) {
         die("Invalid order type: $order_type");
      }

      my $c = $klass->new(data => $order->{data});
      $s .= $c->get($order->{data});
   }

   return $s;
}
1;
__END__

   for my $section (@{ $data }) {
      next if(! defined $section);
      my $part = $section->{type};
      my $klass = "Rex::Converter::Part::$part";

      eval "use $klass";
      if($@) {
         die("Unknown section type: $part");
      }

      $s .= $klass->get($section->{data});

   }

   return $s;
}

1;
