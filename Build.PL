use strict;

use warnings;

use 5.006;

use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'WWW::YouTube::CC',
    license           => 'perl',
    dist_author       => q{Seungwon Jeong <seungwon0@gmail.com>},
    dist_version_from => 'lib/WWW/YouTube/CC.pm',
    build_requires    => {
        'Test::More'        => 0,
        'Test::Differences' => 0,
    },
    requires => {
        'perl'           => 5.010,
        'strict'         => 0,
        'warnings'       => 0,
        'Carp'           => 0,
        'English'        => 0,
        'LWP::Simple'    => 0,
        'HTML::Entities' => 0,
        'Encode'         => 0,
        'autodie'        => 0,
        'Getopt::Long'   => 0,
        'IO::Prompt'     => 0,
    },
    script_files       => [ 'bin/youtube-cc-dl', ],
    add_to_cleanup     => ['youtube-cc-dl-*'],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
