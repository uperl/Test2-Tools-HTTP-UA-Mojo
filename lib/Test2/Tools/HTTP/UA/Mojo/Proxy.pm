package Test2::Tools::HTTP::UA::Mojo::Proxy;

use strict;
use warnings;
use 5.014;
use Mojo::Base 'Mojo::UserAgent::Proxy';

# ABSTRACT: Proxy class for Test2::Tools::HTTP::UA::Mojo
# VERSION

=head1 SYNOPSIS

 use Test2::Tools::HTTP::UA::Mojo;

=head1 DESCRIPTION

This is a private class.  For details on how to use, see
L<Test2::Tools::HTTP::UA::Mojo>.

=cut

has 'apps';
has 'apps_proxy_url';

sub prepare
{
  my ($self, $tx) = @_;

  if($self->apps->uri_to_app($tx->req->url.""))
  {
    $tx->req->proxy($self->apps_proxy_url);
    return;
  }
  else
  {
    return $self->SUPER::prepare($tx);
  }
}

1;

=head1 SEE ALSO

=over 4

=item L<Test2::Tools::HTTP::UA::Mojo>

=back

=cut
