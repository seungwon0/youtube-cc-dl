use strict;

use warnings;

use Test::More tests => 1;

use WWW::YouTube::CC;

my $v_param = 'tuRYbBvOMRo';

my $xml_ref = WWW::YouTube::CC::download_cc_list($v_param);

like( ${$xml_ref}, qr/<track /, 'Download closed caption list' );
