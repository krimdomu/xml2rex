#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package Rex::Converter::Part::Auth;

use strict;
use warnings;

use Rex::Converter::Part::Base;
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

   my $auth = {
      type        => $self->data->attrs("type"),
      user        => sub { eval { return $self->data->user->text; } or do { return undef; } }->(),
      password    => sub { eval { return $self->data->password->text; } or do { return undef; } }->(),
      private_key => sub { eval { return $self->data->private_key->text; } or do { return undef; } }->(),
      public_key  => sub { eval { return $self->data->public_key->text; } or do { return undef; } }->(),
   };

   return $auth;
}

sub get { 
   my ($self) = @_;
   return template('@auth.part', %{ $self->data });
}

1;


__DATA__

@auth.part
<% if($::user) { -%>
set user => "<%= $::user %>";<% } -%>
<% if($::password) { -%>
set password => "<%= $::password %>";<% } -%>
<% if($::private_key) { -%>
set private_key => <%= $::private_key %><% } -%>
<% if($::public_key) { -%>
set public_key => <%= $::public_key %><% } -%>
<% if($::type eq "password") { -%>
set -passauth;
<% } elsif($::type eq "key") { -%>
set -keyauth;
<% } -%>


@end
