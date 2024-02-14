package Log::Rip;

=head1 NAME

Log::Rip - Quickly run through a log file parsing patterns

=cut

=head1 SYNOPSIS

use Log::Rip;

my $ripper = Log::Rip->new(file => 'test.log');

$ripper->match(qr/critical/i, sub { my $line = shift @_; push @critical_messages, $line; });

$ripper->match(qr/\w+o\b/, sub { print "Word $_ ends with o\n" foreach @_; }, 'g');

$ripper->match(qr/^MSG-([0-9]+): (.*)$/, sub { my ($id, $msg) = @_; $messages{$id} = $msg; });

$ripper->run();

=cut

=head1 DESCRIPTION

Handles the monotonous file I/O stuff while the caller focuses on providing
the regexes to match and the callback functions to process the matches.

=cut

=head1 METHODS

=head2 new(file => FILENAME, debug => 1)

Constructs a Log::Rip object to parse file FILENAME. When the debug parameter 
is set, a detailed dump of matches for each line is printed to stderr.

=head2 match($regex, $callback, $modifiers)

When a line of text matching $regex is encountered, the $callback function is 
invoked, with the results of all capture groups provided as arguments to the 
callback. If no capture groups are specified, the entire line is provided to 
the callback function. See SYNOPSIS for examples. The string 'g' may be 
given as the third, optional $modifiers argument to use global regex matching.
If your global regex pattern contains captures groups, use the 'gc' as the 
$modifiers argument.

=head2 run()

Parses the file and runs callbacks on matches.

=cut

use strict;
use warnings;

use Exporter qw/import/;

my @patterns = ();

sub new {
    my ($self, %args) = @_;
    return bless \%args, $self;
}

sub DESTROY {
    @patterns = ();
}

sub _error {
    print STDERR "Log::Rip Error: $_[0]\n";
}

sub match {
    my ($self, $regex, $callback, $modifiers) = @_;
    if ($modifiers and $modifiers !~ m/^[gcN]+$/) { 
        _error "unsupported modifiers: $modifiers";
        return 0;
    }
    push @patterns, [$regex, $callback, $modifiers];
}

sub run {
    my $self = shift;
    (_error "no file given" and return 0) unless $self->{file};
    open (my $fd, '<', $self->{file}) or (_error "file $self->{file} not found" and return 0);
    while (my $line = <$fd>) {
        chomp $line;
        if ($self->{debug}) {
            printf STDERR "Line %d: %s\n", $., $line;
        }
        foreach my $p (@patterns) {
            my ($re, $cb, $mod) = @{$p};
            my @captures = ();
            if ($mod and $mod =~ /g/) {
                @captures = ($line =~ m/($re)/g);
                # If user specified a capture group, remove the full matches
                @captures = @captures[grep $_ % 2, 0..$#captures] if @captures and $mod =~ /c/;
            }
            else {
                if ($mod and $mod =~ /N/) {
                    @captures = ($line) if $line !~ m/$re/;
                }
                else {
                    @captures = ($line =~ m/($re)/);
                }
                # If user specified a capture group, remove the full match
                shift @captures if @captures and @captures > 1;
            }
            $cb->(@captures) if $cb and @captures;
            if ($self->{debug}) {
                print STDERR "  Pattern: $re\n";
                if (@captures) {
                    print STDERR "    Match: $_\n" foreach (@captures);
                }
                else {
                    print STDERR "    Not matched\n";
                }
            }
        }
    }
    close $fd;
}

1;

