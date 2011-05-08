use strict;

use warnings;

use Test::More tests => 2;

use WWW::YouTube::CC;

my $url;
my $got;
my $expected;

$url      = 'http://www.youtube.com/watch?v=tuRYbBvOMRo';
$got      = WWW::YouTube::CC::get_v_param_from_url($url);
$expected = 'tuRYbBvOMRo';
is( $got, $expected, "Get v parameter from $url" );

$url      = 'http://www.youtube.com/watch?v=k6U-i4gXkLM&feature=relmfu';
$got      = WWW::YouTube::CC::get_v_param_from_url($url);
$expected = 'k6U-i4gXkLM';
is( $got, $expected, "Get v parameter from $url" );
