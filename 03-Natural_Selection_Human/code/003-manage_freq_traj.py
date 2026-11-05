## usage: python2 manage_freq_traj.py <clues output prefix> <output prefix>

import numpy as np
import pandas
import sys

inpprefix = sys.argv[1]
outprefix = sys.argv[2]

epochs = np.load('{}.epochs.npy'.format(inpprefix))
freqs = np.load('{}.freqs.npy'.format(inpprefix))
logpost = np.load('{}.post.npy'.format(inpprefix))

post = np.exp(logpost)

def get_lower_post(ref_list):
	ref_list = list(ref_list)
	max_index = int(ref_list.index(max(ref_list)))
	if max_index == 0:
		lower_index = max_index
	else:
		for nu in range(len(ref_list[:max_index])):
			tmp_index = int(max_index-nu)
			if tmp_index == 0:
				lower_index = tmp_index
				break
			else:
				print("tmp_index =" + str(tmp_index))
				if sum(ref_list[tmp_index:]) >= 0.975:
					lower_index = tmp_index
					break
	return(lower_index)

def get_upper_post(ref_list):
	ref_list = list(ref_list)
	max_index = int(ref_list.index(max(ref_list)))
	if max_index == len(ref_list)-1:
		upper_index = max_index
	else:
		for nu in range(len(ref_list[max_index:])):
			tmp_index = max_index+nu
			if tmp_index == (len(ref_list)-1):
				upper_index = tmp_index
				break
			else:
				if sum(ref_list[:tmp_index]) >= 0.975:
					upper_index = tmp_index
					break
	return(upper_index)

data = pandas.DataFrame()
data['GenerationBP'] = map(int, epochs[:-1])
data['Freq'] = data['GenerationBP'].apply(lambda x: freqs[list(post[:,x]).index(max(post[:,x]))])
data['lower_Freq'] = data['GenerationBP'].apply(lambda x: freqs[get_lower_post(list(post[:,x]))])
data['upper_Freq'] = data['GenerationBP'].apply(lambda x: freqs[get_upper_post(list(post[:,x]))])
data['maxPost'] = data['GenerationBP'].apply(lambda x: max(post[:,x]))

data.to_csv(outprefix+'.epochs_maxpost_freq.txt',sep='\t',index=None)

#freqs[list(post[:,1]).index(sorted(post[:,1])[8])]
#freqs[list(post[:,1]).index(sorted(post[:,1])[143])]
#freqs[list(post[:,1]).index(max(post[:,1]))]