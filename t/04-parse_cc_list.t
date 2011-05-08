use strict;

use warnings;

use Test::More tests => 3;

use WWW::YouTube::CC;

my $xml = <<'END_XML';
<?xml version="1.0" encoding="utf-8" ?><transcript_list docid="-5267988442770427622"><track id="0" name="" lang_code="en" lang_original="English" lang_translated="English" lang_default="true"/></transcript_list>
END_XML

my @cc_list = WWW::YouTube::CC::parse_cc_list( \$xml );

is( scalar @cc_list, 1, 'Get closed caption information list' );

is( $cc_list[0]{name},      q{},  'Check name field' );
is( $cc_list[0]{lang_code}, 'en', 'Check lang_code field' );
