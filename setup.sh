# Example environment setup script for Cori
export OMP_NUM_THREADS=32
export KMP_AFFINITY="granularity=fine,compact,1,0"
export KMP_BLOCKTIME=1
export BENCHMARK_VERSION=v0.4.1
module load pytorch-mpi/v0.4.1
