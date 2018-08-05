use v6.c;

unit module Terminal::Spinners:ver<1.1.0>:auth<github:ryn1x>;

class Spinner is export {
    has $.type        = 'classic';
    has $.speed       = 0.08;
    has $!index       = 0;
    has @!classic     = <| / - \\>;
    has @!bounce      = ('[=   ]', '[==  ]', '[=== ]', '[ ===]', '[  ==]',
                         '[   =]', '[    ]', '[   =]', '[  ==]', '[ ===]',
                         '[====]', '[=== ]', '[==  ]', '[=   ]', '[    ]');
    has @!bounce2     = ('( ●    )', '(  ●   )', '(   ●  )', '(    ● )',
                         '(     ●)', '(    ● )', '(   ●  )', '(  ●   )',
                         '( ●    )', '(●     )');
    has @!dots        = <⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏>;
    has @!dots2       = <⢄ ⢂ ⢁ ⡁ ⡈ ⡐ ⡠>;
    has @!dots3       = <⠈ ⠐ ⠠ ⢀ ⡀ ⠄ ⠂ ⠁>;
    has @!three-dots  = <<'.  ' '.. ' '...'>>;
    has @!three-dots2 = <<'.  ' '.. ' '...' ' ..' '  .' '   '>>;
    has @!bar         = <<▁  ▃  ▄  ▅  ▆  ▇  ▆  ▅  ▄  ▃  ▁  ' '>>;
    has @!bar2        = <<▏  ▎  ▍  ▌  ▊  ▉  ▊  ▋  ▌  ▍  ▎  ' '>>;
    has %!types       = classic     => @!classic,
                        bounce      => @!bounce,
                        bounce2     => @!bounce2,
                        dots        => @!dots,
                        dots2       => @!dots2,
                        dots3       => @!dots3,
                        three-dots  => @!three-dots,
                        three-dots2 => @!three-dots2,
                        bar         => @!bar,
                        bar2        => @!bar2;

    method next() {
        # prints the next frame of the spinner animation
        # prints over the previous frame
        print "\b" x %!types{$.type}[0].chars;
        print %!types{$.type}[$!index];
        sleep $!speed;
        $!index = ($!index + 1) % %!types{$.type}.elems;
    }

    method await(Promise $promise) {
        # awaits for a promise to return with a spinner animation
        # returns the result of the promise
        until $promise.status {
            self.next;
        }
        say '';
        return $promise.result;
    }
}

class Bar is export {
    has $.type = 'hash';
    has $.length = 80;
    has @!hash = <[ # . ]>;
    has @!equals = <<[ = ' ' ]>>;
    has %!types = hash => @!hash,
                  equals => @!equals;

    method show($percent is copy) {
        # takes a Rat, Num, Int, Str... and shows a progress bar for that percent
        # prints over the previous progress bar
        $percent = 0 if $percent < 0;
        $percent = 100 if $percent > 100;
        my $percent-string = sprintf '%.2f', $percent;
        my $bar-length = $percent.Int * ($!length - 9) div 100;
        my $blank-space = ($!length - 9) - $bar-length;
        my $pad = '100.00'.chars - $percent-string.chars;
        print "\b" x $.length;
        print %!types{$!type}[0] ~
              %!types{$!type}[1] x $bar-length ~
              %!types{$!type}[2] x $blank-space ~
              %!types{$!type}[3] ~
              ' ' x $pad ~
              $percent-string ~
              '%';
    }
}
