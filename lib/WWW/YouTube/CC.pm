package WWW::YouTube::CC;

use strict;

use warnings;

use 5.010;

use Carp qw< carp >;

use English qw< -no_match_vars >;

use LWP::Simple qw< get >;

use HTML::Entities qw< decode_entities >;

use Encode < encode_utf8 >;

=head1 NAME

WWW::YouTube::CC - Download and Convert YouTube Closed Caption

=head1 VERSION

Version 0.1.0

=cut

our $VERSION = '0.1.0';

=head1 SYNOPSIS

    use WWW::YouTube::CC;

    my $url = 'http://www.youtube.com/watch?v=kKS12iGFyEA';

    # Get v_param
    my $v_param = WWW::YouTube::CC::get_v_param($url);

    # Download and parse closed caption list
    my $xml_ref = WWW::YouTube::CC::download_cc_list($v_param);
    my @cc_list = WWW::YouTube::CC::parse_cc_list($xml_ref);

    # Select a closed caption
    my $name = $cc_list[0]{name};
    my $lang = $cc_list[0]{lang_code};

    # Download closed caption
    $xml_ref = WWW::YouTube::CC::download_cc( $v_param, $name, $lang );

    # Convert closed caption
    my $srt_ref = WWW::YouTube::CC::convert_to_srt($xml_ref);

=head1 SUBROUTINES/METHODS

=head2 get_v_param

Returns v param of the given YouTube URL.

=cut

sub get_v_param {
    my ($url) = @_;

    return if !defined $url;

    return if $url !~ /[?&] v = (?<v_param>[^&]+)/xmsi;

    return $LAST_PAREN_MATCH{v_param};
}

=head2 download_cc_list

Downloads closed caption list of the given v param and returns its
reference.

=cut

sub download_cc_list {
    my ($v_param) = @_;

    return if !defined $v_param;

    my $url = "http://video.google.com/timedtext?type=list&v=$v_param";

    my $xml = get($url);
    if ( !defined $xml ) {
        carp "Cannot fetch the document identified by the given URL: $url\n";
        return;
    }

    return \$xml;
}

=head2 parse_cc_list

Parses the give closed caption list reference and returns list of
hashes containing closed caption information.

=cut

sub parse_cc_list {
    my ($xml_ref) = @_;

    return if !defined $xml_ref;

    # <track id="0" name="" lang_code="en" lang_original="English"
    # lang_translated="English" lang_default="true" cantran="true"/>

    my @tracks = ${$xml_ref} =~ m{(<track .+?/>)}xmsg;

    my @cc_info_list;

    for my $track (@tracks) {
        my %cc_info = $track =~ /(\w+) = "(.*?)"/xmsg;
        push @cc_info_list, \%cc_info;
    }

    return @cc_info_list;
}

=head2 download_cc

Downloads the closed caption of the given arguments and returns its
reference.

=cut

sub download_cc {
    my ( $v_param, $name, $lang ) = @_;

    return if !defined $v_param || !defined $name || !defined $lang;

    my $url = 'http://video.google.com/timedtext?type=track'
        . "&v=$v_param&name=$name&lang=$lang";

    my $xml = get($url);
    if ( !defined $xml ) {
        carp "Cannot fetch the document identified by the given URL: $url\n";
        return;
    }

    return \$xml;
}

=head2 convert_to_srt

Converts the given closed caption reference into SubRip text file
format and returns its reference.

=cut

sub convert_to_srt {
    my ($xml_ref) = @_;

    return if !defined $xml_ref;

    my @texts = ${$xml_ref} =~ m{<text [ ] (.+?) </text>}xmsg;

    # SubRip text file format:
    # Subtitle number
    # Start time --> End time
    # Text of subtitle (one or more lines)
    # Blank line

    # SubRip .srt file example:
    # 1
    # 00:00:20,000 --> 00:00:24,400
    # Altocumulus clouds occur between six thousand
    #
    # 2
    # 00:00:24,600 --> 00:00:27,800
    # and twenty thousand feet above ground level.
    #

    my $srt;

    open my $fh, '>', \$srt;

    my $subtitle_num = 1;

    for my $text (@texts) {

        # Subtitle number
        say {$fh} $subtitle_num;
        $subtitle_num++;

        # Start time --> End time
        $text =~ /start = " (?<start>[\d.]+) "/xms;
        my $start = $LAST_PAREN_MATCH{start};
        $text =~ /dur   = " (?<dur>  [\d.]+) "/xms;
        my $dur = $LAST_PAREN_MATCH{dur} || 0;
        my $end = $start + $dur;
        $start = convert_to_srt_time_format($start);
        $end   = convert_to_srt_time_format($end);
        say {$fh} "$start --> $end";

        # Text of subtitle (one or more lines)
        $text =~ s/.+? >//xms;
        $text =~ tr/\n/ /;
        $text = decode_entities($text);
        $text = decode_entities($text);
        $text = encode_utf8($text);
        say {$fh} $text;

        # Blank line
        say {$fh} q{};
    }

    close $fh;

    return \$srt;
}

=head2 convert_to_srt_time_format

Returns time format string for SubRip text file format of the given
time.

=cut

sub convert_to_srt_time_format {
    my ($time) = @_;

    return if !defined $time;

    my $hours = int($time) / ( 60 * 60 );
    my $mins  = ( int($time) % ( 60 * 60 ) ) / 60;
    my $secs  = int($time) % 60;
    my $msecs = int( ( $time - int($time) ) * 1000 );

    return sprintf '%02d:%02d:%02d,%03d', $hours, $mins, $secs, $msecs;
}

=head1 AUTHOR

Seungwon Jeong, C<< <seungwon0 at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-youtube-cc-dl at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=youtube-cc-dl>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::YouTube::CC


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=youtube-cc-dl>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/youtube-cc-dl>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/youtube-cc-dl>

=item * Search CPAN

L<http://search.cpan.org/dist/youtube-cc-dl/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Seungwon Jeong.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1;    # End of WWW::YouTube::CC
