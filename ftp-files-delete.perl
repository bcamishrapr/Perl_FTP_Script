#!/usr/bin/perl

use strict;
use Net::FTP;

my $host        = "xyz";
my $dir         = "/home/rk/test";
my $user        = "rk";
my $passwd      = "xyz";
my $interval    = 3600*24*1; # 62 day
my $passive     = 1; # my FTP server only works in PASV mode
my $DEBUG       = 0;

my $ftp = Net::FTP->new($host,
 Debug => $DEBUG,
 Passive => $passive)
 or die "Can't open $host\n";
$ftp->login($user, $passwd) or die "Can't log in as $user\n";
$ftp->cwd($dir) or die "Can't chdir to $dir\n";
my @files = $ftp->ls();

foreach my $file (@files) {
my $file_mdtm = $ftp->mdtm($file) or die "Can't find $file in $dir\n";
#if ( (time - $file_mdtm >= $interval) and ($file =~ /\.txt/i) ){} -- to delete files of specific type 
if  (time - $file_mdtm >= $interval)  {
print "File $file is older than $interval secs: deleted\n";
$ftp->delete($file) unless $DEBUG;
}
}
