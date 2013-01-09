#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Rex::Converter::XML2Rex;

use strict;
use warnings;

use Data::Dumper;
use Mojo::DOM;

use Rex::Converter::Base;
use base qw(Rex::Converter::Base);

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = $proto->SUPER::new(@_);

   bless($self, $proto);

   return $self;
}

sub convert {
   my ($self, $source, $dest) = @_;

   my $data = [];
   my $source_xml = eval { local(@ARGV, $/) = ($source); <>; };

   my $dom = Mojo::DOM->new($source_xml);

   my $start_tag = $dom->rex->children;

   my $s = "";

   $start_tag->each(sub {
      my ($tag) = @_;

      my $tag_name = $tag->type;
      my $klass = "Rex::Converter::Part::\u$tag_name";

      eval "use $klass";
      if($@) {
         die("Unknown tag type.");
      }

      my $c = $klass->new(data => $tag);
      push(@{ $data }, { type => "\u$tag_name", data => $c->parse });
   });

   my $rexfile = $self->SUPER::convert($data);

   open(my $fh, ">", $dest) or die($!);
   print $fh $rexfile;
   close($fh);
}

1;
