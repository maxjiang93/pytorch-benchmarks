#!/bin/bash
#SBATCH -N 1
#SBATCH -C haswell
#SBATCH -q debug
#SBATCH -t 30
#SBATCH -d singleton
#SBATCH -J pytorch-bm-hsw
#SBATCH -o logs/%x-%j.out

set -e

# Options
clean=false
models="alexnet vgg11 resnet50 inceptionV3 lstm cnn3d"
if [ $# -ge 1 ]; then models=$@; fi

# Configuration
export OMP_NUM_THREADS=32
export KMP_AFFINITY="granularity=fine,compact,1,0"
export KMP_BLOCKTIME=1
export BENCHMARK_RESULTS_PATH=$SCRATCH/pytorch-benchmarks/hsw-v1.2.0.ddpcpu-n${SLURM_JOB_NUM_NODES}
if $clean; then
    [ -d $BENCHMARK_RESULTS_PATH ] && rm -rf $BENCHMARK_RESULTS_PATH
fi
module load pytorch/v1.2.0

# Run each model
for m in $models; do
    srun -l python train.py -d mpi configs/${m}.yaml
done

echo "Collecting benchmark results..."
python parse.py $BENCHMARK_RESULTS_PATH -o $BENCHMARK_RESULTS_PATH/results.txt
