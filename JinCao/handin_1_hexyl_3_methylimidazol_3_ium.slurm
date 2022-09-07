#!/bin/bash 
#SBATCH -N 1
##SBATCH --time=24:00:00
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=28
#SBATCH --job-name=1_hexyl_3_methylimidazol_3_ium
#SBATCH -p short
#SBATCH --mem=200G
#SBATCH -t 1-00:00:00

module purge
module load gaussian/g16
source /shared/centos7/gaussian/g16/bsd/g16.profile
source /work/hung_group/xu.jiam/miniconda3/bin/activate  ## Load miniconda

export HOME_DIR=$SLURM_SUBMIT_DIR
export GAUSS_SCRDIR=$SLURM_SUBMIT_DIR

date > 1_hexyl_3_methylimidazol_3_ium.log
g16 job_1_hexyl_3_methylimidazol_3_ium.com
date > 1_hexyl_3_methylimidazol_3_ium.log

formchk job_1_hexyl_3_methylimidazol_3_ium_gas.chk vac_1_hexyl_3_methylimidazol_3_ium.fch
formchk job_1_hexyl_3_methylimidazol_3_ium_solv.chk sol_1_hexyl_3_methylimidazol_3_ium.fch

cp /scratch/xu.jiam/multiwfn/settings.inp ./

/scratch/xu.jiam/multiwfn/Multiwfn vac_1_hexyl_3_methylimidazol_3_ium.fch << EOF
7
18
1
y
q
EOF

/scratch/xu.jiam/multiwfn/Multiwfn sol_1_hexyl_3_methylimidazol_3_ium.fch << EOF
7
18
1
y
q
EOF

python chg_swap.py --i 1_hexyl_3_methylimidazol_3_ium

oldpath=`pwd`
cp 1_hexyl_3_methylimidazol_3_ium_resp2.mol2 /scratch/xu.jiam/sobtop
cd /scratch/xu.jiam/sobtop
./sobtop 1_hexyl_3_methylimidazol_3_ium_resp2.mol2 << EOF
2

1
2
3


EOF

cp 1_hexyl_3_methylimidazol_3_ium_resp2.gro $oldpath
cp 1_hexyl_3_methylimidazol_3_ium_resp2.top $oldpath
cp 1_hexyl_3_methylimidazol_3_ium_resp2.itp $oldpath

cd $oldpath

python itp_combin.py --i 1_hexyl_3_methylimidazol_3_ium

module load openmpi/3.1.2
module load python/2.7.15
module load gromacs/2018.4-cpu
source /shared/centos7/gromacs/2018.4-cpu/bin/GMXRC

 
## if ! [ -f "ini_0.gro" ]; then
## mpirun -np 1 gmx_mpi insert-molecules -ci 1_hexyl_3_methylimidazol_3_ium_resp2.gro -nmol 1200 -box 10 10 10 -o ini_0.gro
## 
## else
## mpirun -np 1 gmx_mpi insert-molecules -f ini_0.gro -ci 1_hexyl_3_methylimidazol_3_ium_resp2.gro -nmol 1200 -box 10 10 10 -o ini.gro
## fi

