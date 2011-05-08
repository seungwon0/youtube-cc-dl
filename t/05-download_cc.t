use strict;

use warnings;

use Test::More tests => 1;

use WWW::YouTube::CC;

my $v_param = 'tuRYbBvOMRo';
my $name    = q{};
my $lang    = 'en';

my $xml_ref = WWW::YouTube::CC::download_cc( $v_param, $name, $lang );

like( ${$xml_ref}, qr/<transcript>/, 'Download closed caption' );
