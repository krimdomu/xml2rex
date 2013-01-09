#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Rex::Converter;

use strict;
use warnings;

sub create {
   my ($class, $type, @opts) = @_;

   my $klass = "Rex::Converter::$type";

   eval "use $klass;";
   if($@) {
      die("Error Loading $klass.");
   }

   return $klass->new(@opts);
}

1;
