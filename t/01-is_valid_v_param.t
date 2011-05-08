use strict;

use warnings;

use Test::More tests => 4;

use WWW::YouTube::CC;

my $v_param;

$v_param = 'tuRYbBvOMRo';
ok( WWW::YouTube::CC::is_valid_v_param($v_param), $v_param );

$v_param = 'tuRYbBvOMR';
ok( !WWW::YouTube::CC::is_valid_v_param($v_param), $v_param );

$v_param = '???????????';
ok( !WWW::YouTube::CC::is_valid_v_param($v_param), $v_param );

$v_param = 'http://www.youtube.com/watch?v=tuRYbBvOMRo';
ok( !WWW::YouTube::CC::is_valid_v_param($v_param), $v_param );
