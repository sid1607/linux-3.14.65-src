import sys

psm_power_mW=256
active_power_mW=890
if __name__ == '__main__':
	with open(sys.argv[1], 'r') as f:
		for line in f:
			try:
				print line.split('] ')[1]
			except:
				continue