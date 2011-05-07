#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'WWW::YouTube::CC' ) || print "Bail out!\n";
}

diag( "Testing WWW::YouTube::CC $WWW::YouTube::CC::VERSION, Perl $], $^X" );
