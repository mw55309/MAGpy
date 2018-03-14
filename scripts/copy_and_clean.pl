#!/usr/bin/env perl

use Bio::SeqIO;
use Bio::PrimarySeq;
use File::Basename;

my $src  = shift;
my $dest = shift;

my @faa = <$src/*.faa>;

foreach $fa (@faa) {
	my $base = basename $fa, ".faa";

	my $out = Bio::SeqIO->new(-file => ">$dest/$base.faa", -format => 'fasta');
	
	my $in = Bio::SeqIO->new(-file => "$fa", -format => 'fasta');

	while(my $seq = $in->next_seq()) {
		my $id = $base . $seq->display_id;
		my $de = $seq->description;
		my $se = $seq->seq;

		my $ns = Bio::PrimarySeq->new(-id => $id, -desc => $de, -seq => $se);

		$out->write_seq($ns);
	}
}
