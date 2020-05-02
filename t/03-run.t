use strict;
use warnings;
use Test::More;
#use Config;
use Test::Alien;
use Alien::sqlite;
use Env qw ( @PATH @LD_LIBRARY_PATH @DYLD_LIBRARY_PATH );

alien_ok 'Alien::sqlite';

diag ('bin dir: ' . join (' ', Alien::sqlite->bin_dir));
my @bin = Alien::sqlite->bin_dir;

#  nasty hack
unshift @LD_LIBRARY_PATH, Alien::sqlite->dist_dir . '/lib';
unshift @DYLD_LIBRARY_PATH, Alien::sqlite->dist_dir . '/lib';
unshift @PATH, @bin;

my $version = `sqlite3.exe -version`;
diag 'sqlite3 -version: ' . $version // '';
ok (defined $version, 'got a defined version');

done_testing();

 
__DATA__

//  A very simple test.  It really only tests that we can load proj4.

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "stdio.h"
#include <spatialite.h>

int main()
{
   printf("Hello, World!");
   return 0;
}

const char *
version(const char *class)
{
   return "v1";
}

MODULE = TA_MODULE PACKAGE = TA_MODULE
 
const char *version(class);
    const char *class;

