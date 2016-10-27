package Getopt::Long::Descriptive::Patch::DumpAndExit;

# DATE
# VERSION

use 5.010001;
use strict;
no warnings;

use Data::Dmp;
use Module::Patch 0.19 qw();
use base qw(Module::Patch);

our %config;

sub _dump {
    print "# BEGIN DUMP $config{-tag}\n";
    local $Data::Dmp::OPT_DEPARSE = 0;
    say dmp($_[0]);
    print "# END DUMP $config{-tag}\n";
}

sub _build_describe_options {
    sub {
        _dump(\@_);
        $config{-exit_method} eq 'exit' ? exit(0) : die;
    },
}

sub patch_data {
    return {
        v => 3,
        patches => [
            {
                action      => 'replace',
                sub_name    => '_build_describe_options',
                code        => \&_build_describe_options,
            },
        ],
        config => {
            -tag => {
                schema  => 'str*',
                default => 'TAG',
            },
            -exit_method => {
                schema  => 'str*',
                default => 'exit',
            },
        },
   };
}

1;
# ABSTRACT: Patch Getopt::Long::Descriptive to dump option spec and exit

=for Pod::Coverage ^(patch_data)$

=head1 DESCRIPTION

This patch can be used to extract Getopt::Long::Descriptive options
specification from a script by running the script but exiting early after
getting the specification.
