#!/usr/bin/perl

=pod

=head1 NAME

tari.pl

=head1 DESCRIPTION

tari is archived from the file list of include.

=cut

use strict;
use warnings;
use FindBin qw($Script);
use File::Basename;
use File::stat;
use Fcntl qw(:DEFAULT :flock);
use Getopt::Long;

my ($dir, $yes, $debug);
GetOptions(
  'change=s' => \$dir,
  'yes'      => \$yes,
  'help'     => \&_help,
  'version'  => \&_version,
  'debug'    => \$debug,
);

# Init
&_help if (scalar(@ARGV) eq 0);

my ($list) = @ARGV;

# Main
eval {&_exec};
if ($@) {
  chomp(my $message = $@); 
  print "FAIL: $message\n";
  exit 1;
}

exit;

## Private function
sub _exec {
  my @basename = split(/\./, basename($list));
  my @files = ($basename[0].'.tar');
  my $path = $files[0];

  if (!defined($yes)) {
    foreach my $file(@files) {
      if (-f $file) {
        print "overwrite $file? (y/n):";
        chomp(my $confirm = <STDIN>);
        exit if ($confirm ne 'y');
      }
    }
  }

  @files = &_get_files($list, $dir);
  &_set_archive($path, $dir, @files);
}

## Reading of list.
sub _get_files {
  my $path = shift;
  my $dir = shift;
  my @files;
  local *FILE;

  open FILE, '<'.$path or die "can not open file: $path";
  flock FILE, LOCK_EX;
  my @rows = <FILE>;
  close FILE;

  foreach my $row(@rows) {
    chomp($row);
    my @cols = split(/\t/, $row);
    if (defined($cols[0]) && $cols[0] =~ /^\//) {
      my %file=(
        'path'  => $cols[0],
        'user'  => $cols[1],
        'group' => $cols[2],
        'size'  => '',
        'md5'   => '',
     );

      my $path = $file{path};
      $path = defined($dir) ? $dir.$file{path} : '.'.$file{path};
      $file{type} = &_get_file_type($path);

      my $stat = stat($path);
      my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($stat->mtime);

      $file{time} = sprintf "%04d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon+1, $mday, $hour, $min, $sec;
      $file{mode} = sprintf "%04o", $stat->mode & 07777;

      $file{user} = getpwuid($stat->uid) if (!defined($file{user}));
      $file{group} = getgrgid($stat->gid) if (!defined($file{group}));

      if ($file{type} ne 'dir') {
        $file{size} = $stat->size;
        my $cmd = 'openssl md5 \''.$path.'\'';
        my @md5 = split(/\s/, `$cmd`);
        $file{md5} = $md5[1];
      }

      push @files, \%file;
    }
  }

  return @files;
}

## File exists.
sub _get_file_type {
  my $path = shift;
  my $type;

  if (-e $path) {
    if (-d $path) {
      $type = 'dir';
    } else {
      if (-l $path) {
        $type = 'symlink';
      } else {
        $type = 'file';
      }
    }
  } else {
    die 'file not exists: '.$path;
  }

  return $type;
}

## Making of archive.
sub _set_archive {
  my $path = shift;
  my $dir = shift;
  my @files= @_;
  my $create;

  print "[\n" if (defined($debug));

  foreach my $file(@files) {
    &_put_json($file) if (defined($debug));

    if ($file->{type} eq 'file') {
      my $cmd = 'tar ';
      $cmd .= defined($create) ? '-r' : '-c';
      $cmd .= 'f '.$path.' ';
      $cmd .= defined($dir) ? '-C '.$dir : '';
      $cmd .= ' .\''.$file->{path}.'\'';
      $create = 'false';
      
      die "command error: $cmd" if (system($cmd) >> 8);
    }
  }

  print "]\n" if (defined($debug));
}

## JSON output
sub _put_json {
  my $file = shift;
  print <<CONTENT;
  {
    "path": "$file->{path}",
    "type": "$file->{type}",
    "user": "$file->{user}",
    "group": "$file->{group}",
    "mode": "$file->{mode}",
    "size": $file->{size},
    "time": "$file->{time}",
    "md5": "$file->{md5}"
  },
CONTENT
}

sub _help {
  print <<CONTENT;
Usage: $Script [OPTION] [FILE]

Startup:
  -c  --change   Change to directory
  -y  --yes      Answer yes for all questions
  -h, --help     Output usage information
  -v, --version  Output the version number
  -d, --debug    Enable debug output

Example:
  $Script list.txt

CONTENT
  exit 0;
}

sub _version {
  print <<CONTENT;
1.0.2
CONTENT
  exit 0;
}

__END__
