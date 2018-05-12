package Test2::Tools::HTTP::UA::Mojo;

use strict;
use warnings;
use 5.01001;
use Mojolicious 7.00;
use HTTP::Response;
use HTTP::Message::PSGI;
use Scope::Guard qw( guard );
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
  $self->apps->base_url($self->ua->server->url->to_string);
  warn "max redirects", $self->ua->max_redirects;
}

sub request
{
  my($self, $req, %options) = @_;

  require Mojo::Transaction::HTTP;
  require Mojo::Message::Request;
  require Mojo::URL;

  # Add the User-Agent header to the HTTP::Request
  # so that T2::T::HTTP can see it in diagnostics
  $req->header('User-Agent' => $self->ua->transactor->name)
    unless $req->header('User-Agent');

  my $mojo_req = Mojo::Message::Request->new;
  $mojo_req->parse($req->to_psgi);
  $mojo_req->url(Mojo::URL->new($req->uri.''))
    if $req->uri !~ /^\//;

  my $tx = Mojo::Transaction::HTTP->new(req => $mojo_req);
  
  my $save_max_redirects = $self->ua->max_redirects;
  my $guard = guard sub { $self->ua->max_redirects($save_max_redirects) };
  
  if($options{follow_redirects})
  {
    $self->ua->max_redirects(10);
  }
  else
  {
    $self->ua->max_redirects(0);
  }

  warn "max_redirects = ", $self->ua->max_redirects;
  $self->ua->start($tx);
  
  if(my $err = $tx->error)
  {
    my $res = HTTP::Response->new(500, 'Internal Error');
    $res->header("Client-Warning" => $err->{message});
    return $res;
  }
  else
  {
    my $res = HTTP::Response->parse(
      $tx->res->to_string
    );
    $res->request($req);
    return $res;
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
