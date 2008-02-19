use Module::Build;

my $build = Module::Build->new(
    module_name => 'Algorithm::TokenBucket',
    license     => 'artistic',
    dist_version_from => 'lib/Algorithm/TokenBucket.pm',
    build_requires => {
        'Test::NoWarnings'  => 0,
        'Time::HiRes'       => 0,
    },
    sign        => 1,
);

$build->create_build_script;
