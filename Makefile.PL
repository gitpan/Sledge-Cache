use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'         => 'Sledge::Cache',
    'VERSION_FROM' => 'lib/Sledge/Cache.pm', # finds $VERSION
    'PREREQ_PM'    => {
        Test::More      => 0.32,
        Class::Accessor => 0.22,
        Test::Exception => 0.21,
    },
);
