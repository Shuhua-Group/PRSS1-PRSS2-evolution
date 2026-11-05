#coding:utf-8

import os 

def prepare_Bin_50():
	#bin 50gens
	fout_path = "/picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.beta.txt"
	fout_file = open(fout_path,"w")
	for nu in range(151):
		gen = float(nu)*50
		fout_file.write(str(gen) + "\n")
	fout_file.close()

def prepare_Bin_200():
	#bin 200gens
	fout_path = "/picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.Bin_200gens.txt"
	fout_file = open(fout_path,"w")
	for nu in range(39):
		gen = float(nu)*200
		fout_file.write(str(gen) + "\n")
	fout_file.close()

def prepare_Bin_350():
	#bin 350gens
	fout_path = "/picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.Bin_350gens.txt"
	fout_file = open(fout_path,"w")
	for nu in range(23):
		gen = float(nu)*350
		fout_file.write(str(gen) + "\n")
	fout_file.close()


def prepare_Bin200_Cutoff3000():
	#bin 200gens
	fout_path = "/picb/humpopg-bigdata5/xiebo/software/clues/clues-master/example/timeBins.Bin_200gens.Cutoff3000.txt"
	fout_file = open(fout_path,"w")
	for nu in range(16):
		gen = float(nu)*200
		fout_file.write(str(gen) + "\n")
	fout_file.close()

prepare_Bin200_Cutoff3000()