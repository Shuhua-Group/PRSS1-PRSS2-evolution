#!/usr/bin/perl
use strict;

open(INFILE,"$ARGV[0]");
my @infile=<INFILE>;
chomp @infile;
close INFILE;

open(OUT,">>$ARGV[0].out");

my @cp1_CN3=(0,1,1,1,1,0,0,0,0,1,0,0,0,0,0,1,1,1,0,1,0,1,0,0,0,1,0,0);
my @cp1_CN5=(1,1,1,0,0,1,0,1,0,0,0,1,1,0,1,0,0,1,0,0,1,0,0,0,0,1,0,0);
my @cp1_CNC=(0,0,0,0,0,1,0,1,0,0,0,1,1,0,1,0,0,1,0,0,0,0,0,0,0,1,0,1);
my @cp2_CN3=(1,1,1,0,1,1,0,1,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,0,1,1,1);
my @cp2_CN5=(0,1,1,0,1,0,0,0,1,1,1,0,1,1,0,1,1,0,1,0,1,1,1,1,0,1,1,1);
my @cp2_CNC=(0,1,1,1,1,0,0,0,0,1,0,0,1,1,1,0,0,0,0,0,1,0,0,1,0,1,0,1);
my @cp5_CN3=(1,0,0,0,1,0,0,1,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,0,1,1,1,1);
my @cp5_CN5=(0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
my @cp5_CNC=(1,0,0,0,0,1,0,1,1,0,0,1,0,1,0,0,0,1,1,0,0,1,1,0,0,0,0,0);
#analysis
for(my $i=0;$i<@infile;$i++){
	my @onehap=split("\t",@infile[$i]);
	print OUT @onehap[0]."\t";
	for(my $j=1;$j<@onehap;$j++){
		print OUT @onehap[$j];
	}
	my $CN3dist=0;
	my $CN5dist=0;
	my $CNCdist=0;
	for(my $j=1;$j<=28;$j++){
		#copy1
		my $k=$j-1;
		if (@onehap[$j] != @cp1_CN3[$k]){
			$CN3dist++;
		}
		if (@onehap[$j] != @cp1_CN5[$k]){
			$CN5dist++;
		}
		if (@onehap[$j] != @cp1_CNC[$k]){
			$CNCdist++;
		}
	}
	if ($CN3dist < $CN5dist and $CN3dist < $CNCdist){
		print OUT "\tCN3\t".$CN3dist;
	}elsif ($CN5dist < $CN3dist and $CN5dist < $CNCdist){
		print OUT "\tCN5\t".$CN5dist;
	}elsif ($CNCdist < $CN3dist and $CNCdist < $CN5dist){
		print OUT "\tCNC\t".$CNCdist;
	}else{
		print OUT "\tunknown\t".$CN3dist.",".$CN5dist.",".$CNCdist;
	}

	my $CN3dist=0;
	my $CN5dist=0;
	my $CNCdist=0;
	for(my $j=29;$j<=56;$j++){
		#copy2
		my $k=$j-29;
		if (@onehap[$j] != @cp2_CN3[$k]){
			$CN3dist++;
		}
		if (@onehap[$j] != @cp2_CN5[$k]){
			$CN5dist++;
		}
		if (@onehap[$j] != @cp2_CNC[$k]){
			$CNCdist++;
		}
	}
	if ($CN3dist < $CN5dist and $CN3dist < $CNCdist){
		print OUT "\tCN3\t".$CN3dist;
	}elsif ($CN5dist < $CN3dist and $CN5dist < $CNCdist){
		print OUT "\tCN5\t".$CN5dist;
	}elsif ($CNCdist < $CN3dist and $CNCdist < $CN5dist){
		print OUT "\tCNC\t".$CNCdist;
	}else{
		print OUT "\tunknown\t".$CN3dist.",".$CN5dist.",".$CNCdist;
	}

	my $CN3dist=0;
	my $CN5dist=0;
	my $CNCdist=0;
	for(my $j=57;$j<=84;$j++){
		#copy5
		my $k=$j-57;
		if (@onehap[$j] != @cp5_CN3[$k]){
			$CN3dist++;
		}
		if (@onehap[$j] != @cp5_CN5[$k]){
			$CN5dist++;
		}
		if (@onehap[$j] != @cp5_CNC[$k]){
			$CNCdist++;
		}
	}
	if ($CN3dist < $CN5dist and $CN3dist < $CNCdist){
		print OUT "\tCN3\t".$CN3dist;
	}elsif ($CN5dist < $CN3dist and $CN5dist < $CNCdist){
		print OUT "\tCN5\t".$CN5dist;
	}elsif ($CNCdist < $CN3dist and $CNCdist < $CN5dist){
		print OUT "\tCNC\t".$CNCdist;
	}else{
		print OUT "\tunknown\t".$CN3dist.",".$CN5dist.",".$CNCdist;
	}
	print OUT "\n";
}
close (OUT);


