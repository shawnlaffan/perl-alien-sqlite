use strict;
use warnings;
use Test::More;
use Alien::spatialite;

diag( 'NAME=' . Alien::spatialite->config('name') );
diag( 'VERSION=' . Alien::spatialite->config('version') );

my $alien = Alien::spatialite->new;

diag 'CFLAGS: ' . $alien->cflags;

SKIP: {
    skip "system libs may not need -I or -L", 2
        if $alien->install_type('system');
    like( $alien->cflags // '', qr/-I/ , 'cflags');
    like( $alien->libs // '',   qr/-L/ , 'libs');
}


done_testing();

