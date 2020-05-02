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

my $sqlite3_exe = "$bin[0]/sqlite3.exe";
my $version = qx ( $sqlite3_exe -version );
if ($? == -1) {
    diag "failed to execute: $!\n";
}
elsif ($? & 127) {
    diag sprintf "child died with signal %d, %s coredump\n",
        ($? & 127),  ($? & 128) ? 'with' : 'without';
}
else {
    diag sprintf "$sqlite3_exe exited with value %d\n", $? >> 8;
    objdump($sqlite3_exe);
}
diag 'sqlite3 -version: ' . $version // '';

ok (defined $version, 'got a defined version');

done_testing();

sub objdump {
   my ($dll) = @_;
   
   my $have_fw = require 'File::Which';
   return if !$have_fw;
   
   my $objdump = File::Which::which 'objdump';
   my @contents = `$objdump -p $dll`;
   my @lines = grep {'DLL Name'} @contents;
   diag join ' ', @lines;
   return;
}