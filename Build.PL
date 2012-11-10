use Module::Build;

my $build = Module::Build->new(
    module_name => 'Algorithm::TokenBucket',
    license     => 'gpl',
    dist_version_from   => 'lib/Algorithm/TokenBucket.pm',
    build_requires      => {
        'Test::NoWarnings'  => 0,
        'Time::HiRes'       => 0,
    },
    configure_requires  => { 'Module::Build' => 0.40 },
    meta_merge  => {
        resources   => {
            repository      => 'https://bitbucket.org/kapp/algorithm-tokenbucket',
        },
    },
);

$build->create_build_script;
