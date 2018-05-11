package Test2::Tools::HTTP::UA::Mojo;

use strict;
use warnings;
use 5.01001;
use Mojolicious 7.00;
use HTTP::Response;
use HTTP::Message::PSGI;
use parent 'Test2::Tools::HTTP::UA';

# ABSTRACT: Mojo user agent wrapper for Test2::Tools::HTTP
# VERSION

=head1 SYNOPSIS

 use Test2::Tools::HTTP;
 use Mojo::UserAgent;
 
 http_ua( Mojo::UserAgent->new )
 
 http_request(
   GET('http://example.test'),
   http_response {
     http_code 200;
     http_response match qr/something/;
     ...
   }
 );;
 
 done_testing;

=head1 DESCRIPTION

This module is a user agent wrapper for L<Test2::Tools::HTTP> that allows you
to use L<Mojo::UserAgent> as a user agent for testing.

=cut

sub instrument
{
  my($self) = @_;
}

sub request
{
  my($self, $req, %options) = @_;

  require Mojo::Transaction::HTTP;
  require Mojo::Message::Request;
  
  # Add the User-Agent header to the HTTP::Request
  # so that T2::T::HTTP can see it in diagnostics
  $req->header('User-Agent' => $self->ua->transactor->name)
    unless $req->header('User-Agent');

  my $mojo_req = Mojo::Message::Request->new;
  $mojo_req->parse($req->to_psgi);

  my $tx = Mojo::Transaction::HTTP->new(req => $mojo_req);
  
  $self->ua->start($tx);
  
  if(my $err = $tx->error)
  {
    my $res = HTTP::Response->new(500, 'Internal Error');
    $res->header("Client-Warning" => $err->{message});
    return $res;
  }
  else
  {
    return HTTP::Response->parse(
      $tx->res->to_string
    );
  }
}

1;

=head1 SEE ALSO

=over 4

=item L<Test2::Tools::HTTP>

=item L<Mojo::UserAgent>

=item L<Test::Mojo>

=back

=cut
