#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Requires 'Text::SimpleTable';
use File::Basename;

plan skip_all => 'this test requires "jshint" command'
  unless `jshint --version` =~ /\d/;

my @files = (<static/*/*.js>, <static/*/*/*.js>, <static/*/*/*/*.js>);

my %WHITE_LIST = map { $_ => 1 } qw(
    bootstrap-dropdown.js
    bootstrap-tooltip.js
    es5-shim.min.js
    micro-location.js
    micro_template.js
);

my $table = Text::SimpleTable->new( 25, 5 );

for my $file (@files) {
    next if $WHITE_LIST{basename($file)};
    next if basename($file) =~ /jquery-[0-9.]+.min.js$/;

    my $out = `jshint $file`;
    my $err = 0;
    if ( $out =~ /(\d+) errors?/ ) {
        ( $err ) = ( $1 );
        is($err, 0, $file)
            or note $out;
    }
    else {
        ok(1);
    }
    $table->row( basename($file), $err );
}

note $table->draw;

done_testing;
