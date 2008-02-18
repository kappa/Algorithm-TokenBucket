unless (eval "use Module::Build::Compat 0.02; 1" ) {
    print "This module requires Module::Build to install itself.\n";
    warn " *** Cannot install without Module::Build.  Exiting ...\n";
    exit 1;
}

Module::Build::Compat->run_build_pl(args => \@ARGV);
Module::Build::Compat->write_makefile;
