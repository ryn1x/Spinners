#!/usr/bin/env raku
use v6.c;
use Test;
use Terminal::Spinners;

plan 2;

my $classic = Spinner.new;
my $hash-bar = Bar.new;

my class OutputCapture {
    # credit M. Lenz, Perl 6 Fundamentals
    has @!lines;
    method print(\s) {
        @!lines.push(s);
    }
    method captured() {
    @!lines.join;
    }
}

my $spinner-output = do {
    my $*OUT = OutputCapture.new;
    $classic.next;
    $classic.next;
    $classic.next :now;
    $*OUT.captured;
}

my $bar-output = do {
    my $*OUT = OutputCapture.new;
    $hash-bar.show: 0.Rat;
    $hash-bar.show: 0.Num;
    $hash-bar.show: 0.Int;
    $hash-bar.show: (1/3*100).Rat;
    $hash-bar.show: (1/3*100).Num;
    $hash-bar.show: 50.Rat;
    $hash-bar.show: 50.Num;
    $hash-bar.show: 50.Int;
    $hash-bar.show: 100.Rat;
    $hash-bar.show: 100.Num;
    $hash-bar.show: 100.Int;
    $hash-bar.show: 100, :now;
    $*OUT.captured;
}

my $bar0-string = '[' ~
                  '#' x 0 ~
                  '.' x 71 ~
                  ']' ~
                  '  ' ~
                  '0.00%';

my $bar33-string = '[' ~
                  '#' x 23 ~
                  '.' x 48 ~
                  ']' ~
                  ' ' ~
                  '33.33%';

my $bar50-string = '[' ~
                    '#' x 35 ~
                    '.' x 36 ~
                    ']' ~
                    ' ' ~
                    '50.00%';

my $bar100-string = '[' ~
                    '#' x 71 ~
                    '.' x 0 ~
                    ']' ~
                    '100.00%';

is $spinner-output, "\b|\b/-", 'Spinner next works';
is $bar-output, "\b" x 80 ~
                $bar0-string ~
                "\b" x 80 ~
                $bar0-string ~
                "\b" x 80 ~
                $bar0-string ~
                "\b" x 80 ~
                $bar33-string ~
                "\b" x 80 ~
                $bar33-string ~
                "\b" x 80 ~
                $bar50-string ~
                "\b" x 80 ~
                $bar50-string ~
                "\b" x 80 ~
                $bar50-string ~
                "\b" x 80 ~
                $bar100-string ~
                "\b" x 80 ~
                $bar100-string ~
                "\b" x 80 ~
                $bar100-string ~
                $bar100-string,
    'Bar show works';
