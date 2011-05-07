use strict;

use warnings;

use Test::More tests => 1;

use Test::Differences;

use WWW::YouTube::CC;

my $xml = <<'END_XML';
<?xml version="1.0" encoding="utf-8" ?><transcript><text start="0"></text><text start="0" dur="2.4">ANNOUNCER: Open content is
provided under a creative</text><text start="2.4" dur="1.44">commons license.</text><text start="3.84" dur="3">Your support will help MIT
OpenCourseWare continue to</text><text start="6.84" dur="3.67">offer high quality educational
resources for free.</text><text start="10.51" dur="2.88">To make a donation, or view
additional materials from</text><text start="13.39" dur="3.21">hundreds of MIT courses,
visit MIT OpenCourseWare</text><text start="16.6" dur="3.33">at ocw.mit.edu .</text>.</text></transcript>
END_XML

my $expected = <<'END_SRT';
1
00:00:00,000 --> 00:00:00,000


2
00:00:00,000 --> 00:00:02,399
ANNOUNCER: Open content is provided under a creative

3
00:00:02,399 --> 00:00:03,839
commons license.

4
00:00:03,839 --> 00:00:06,839
Your support will help MIT OpenCourseWare continue to

5
00:00:06,839 --> 00:00:10,509
offer high quality educational resources for free.

6
00:00:10,509 --> 00:00:13,390
To make a donation, or view additional materials from

7
00:00:13,390 --> 00:00:16,600
hundreds of MIT courses, visit MIT OpenCourseWare

8
00:00:16,600 --> 00:00:19,929
at ocw.mit.edu .

END_SRT

my $srt_ref = WWW::YouTube::CC::convert_to_srt( \$xml );

eq_or_diff( ${$srt_ref}, $expected, 'Convert to SRT format' );
