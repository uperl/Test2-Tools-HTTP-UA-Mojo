use Test2::V0 -no_srand => 1;
use Test2::Tools::HTTP;
use Test::Mojo;
use Mojolicious::Lite;
use HTTP::Request::Common;

get '/foo' => sub {
  my($c) = @_;
  $c->render(text => "hello world\n");
};

my $t = Test::Mojo->new;

app->log->unsubscribe('message');
app->log->on(message => sub {
  my($log, $level, @lines) = @_;
  note "[$level] $_" for @lines;
});

$t->get_ok('/foo')
  ->status_is(200)
  ->content_is("hello world\n");

http_ua($t->ua);

isa_ok( http_ua, 'Mojo::UserAgent' );

http_request(
  GET('/foo'),
  http_response {
    http_code 200;
    http_content "hello world\n";
  }
);
  

done_testing
