use List::Util qw(any);
use List::MoreUtils qw(first_index);
use Term::ANSIColor;
use strict;

my @strings = qw(E A D G B E);
my @sharps = qw(C C# D D# E F F# G G# A A# B);
my @flats = qw(C Db D Eb E F Gb G Ab A Bb B);
my @major = qw(2 2 1 2 2 2 1);
my @minor = qw(2 1 2 2 1 2 2);
my $num_frets = 16;
my @flat_keys_minor = qw(D G C F Bb Eb);
my @flat_keys_major = qw(F Bb Eb Ab Db Gb Cb);
my @sharp_keys_minor = qw(A E B F# C# G# D#);
my @sharp_keys_major = qw(C G D A E B F# C#);

my @color_config = qw(white red green yellow blue magenta cyan);

my $pos;
my @scale;

my $key = $ARGV[0];
my $major_or_minor = $ARGV[1];
my @chromatic;

if ($major_or_minor eq 'major') {
  if (any { $_ eq $key } @flat_keys_major) {
    @chromatic = @flats;
    $pos = first_index { $_ eq $key } @flats;
    for (@major) {
      push @scale, $flats[$pos];
      $pos = ($pos + $_) % (scalar @flats);
    }
  } elsif (any { $_ eq $key } @sharp_keys_major) {
    @chromatic = @sharps;
    $pos = first_index { $_ eq $key } @sharps;
    for (@major) {
      push @scale, $sharps[$pos];
      $pos = ($pos + $_) % (scalar @sharps);
    }
  } else {
    die 'not found';
  }
} elsif ($major_or_minor eq 'minor') {
  if (any { $_ eq $key } @flat_keys_minor) {
    @chromatic = @flats;
    $pos = first_index { $_ eq $key } @flats;
    for (@minor) {
      push @scale, $flats[$pos];
      $pos = ($pos + $_) % (scalar @flats);
    }
  } elsif (any { $_ eq $key } @sharp_keys_minor) {
    @chromatic = @sharps;
    $pos = first_index { $_ eq $key } @sharps;
    for (@minor) {
      push @scale, $sharps[$pos];
      $pos = ($pos + $_) % (scalar @sharps);
    }
  } else {
    die 'not found';
  }
} else {
  die 'not found';
}

my @strings_display_order = reverse @strings;

print " ";
for (0..$num_frets) {
  printf "%-5s", $_;
}
print "\n";

for my $string_index (0..$#strings_display_order) {
  my $string = $strings_display_order[$string_index];
  $pos = first_index { $_ eq $string } @chromatic;
  for my $fret (0..$num_frets) {
    my $note = $chromatic[($pos + $fret) % (scalar @chromatic)];
    my $degree = first_index { $_ eq $note } @scale;
    if ($fret == 0) {
      print " ";
    } else {
      print "─";
    }
    if ($degree != -1) {
      print colored($note, $color_config[$degree]);
      if (length($note) == 1) {
        if ($fret == 0) {
          print " ";
        } else {
          print "─";
        }
      }
    } else {
      if ($fret == 0) {
        print "  ";
      } else {
        print "──";
      }
    }
    if ($fret == 0) {
      print " ";
      if ($string_index == 0) {
        print "┌";
      } elsif ($string_index == 5) {
        print "└";
      } else {
        print "├";
      }
    } else {
      print "─";
      if ($string_index == 0) {
        print "┬";
      } elsif ($string_index == 5) {
        print "┴";
      } else {
        print "┼";
      }
    }
  }
  print "\n";
}
