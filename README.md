# Test2::Tools::HTTP::UA::Mojo ![static](https://github.com/uperl/Test2-Tools-HTTP-UA-Mojo/workflows/static/badge.svg) ![linux](https://github.com/uperl/Test2-Tools-HTTP-UA-Mojo/workflows/linux/badge.svg) ![macos](https://github.com/uperl/Test2-Tools-HTTP-UA-Mojo/workflows/macos/badge.svg) ![windows](https://github.com/uperl/Test2-Tools-HTTP-UA-Mojo/workflows/windows/badge.svg)

Mojo user agent wrapper for Test2::Tools::HTTP

# SYNOPSIS

```perl
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
```

# DESCRIPTION

This module is a user agent wrapper for [Test2::Tools::HTTP](https://metacpan.org/pod/Test2::Tools::HTTP) that allows you
to use [Mojo::UserAgent](https://metacpan.org/pod/Mojo::UserAgent) as a user agent for testing.

# SEE ALSO

- [Test2::Tools::HTTP](https://metacpan.org/pod/Test2::Tools::HTTP)
- [Mojo::UserAgent](https://metacpan.org/pod/Mojo::UserAgent)
- [Test::Mojo](https://metacpan.org/pod/Test::Mojo)

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2018-2022 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
