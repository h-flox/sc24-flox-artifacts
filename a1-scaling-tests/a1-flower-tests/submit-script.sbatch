#!/bin/bash
#SBATCH --job-name="flower-test"
#SBATCH --output="flower-test-out.3.single.out"
#SBATCH --partition=compute
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --mem=240G
#SBATCH --account=ind136
#SBATCH --export=ALL
#SBATCH -t 01:30:00

export NODES=$SLURM_JOB_NUM_NODES
ipad=$(hostname -I | awk '{print $3}')
echo $ipad

/bin/bash
/home/chard/miniconda3/bib/conda activate flower-test

for num_workers in 1 2 4 8 16 32 64 128; do

	timeout 600 python /home/chard/flox-scaling-tests/a1-flower-tests/server.py --clients $num_workers --ip $ipad --model 3 &

	srun --ntasks 1 -l --exclude=$SLURMD_NODENAME /home/chard/flox-scaling-tests/a1-flower-tests/run-client.sh $num_workers 3 $ipad
	wait
done
