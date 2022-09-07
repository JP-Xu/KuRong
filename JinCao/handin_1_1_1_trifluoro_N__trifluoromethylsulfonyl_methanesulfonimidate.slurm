#!/bin/bash 
#SBATCH -N 1
##SBATCH --time=24:00:00
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=28
#SBATCH --job-name=1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate
#SBATCH -p short
#SBATCH --mem=200G
#SBATCH -t 1-00:00:00

module purge
module load gaussian/g16
source /shared/centos7/gaussian/g16/bsd/g16.profile
source /work/hung_group/xu.jiam/miniconda3/bin/activate  ## Load miniconda

export HOME_DIR=$SLURM_SUBMIT_DIR
export GAUSS_SCRDIR=$SLURM_SUBMIT_DIR

date > 1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate.log
g16 job_1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate.com
date > 1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate.log

formchk job_1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate_gas.chk vac_1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate.fch
formchk job_1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate_solv.chk sol_1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate.fch

cp /scratch/xu.jiam/multiwfn/settings.inp ./

/scratch/xu.jiam/multiwfn/Multiwfn vac_1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate.fch << EOF
7
18
1
y
q
EOF

/scratch/xu.jiam/multiwfn/Multiwfn sol_1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate.fch << EOF
7
18
1
y
q
EOF

python chg_swap.py --i 1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate

oldpath=`pwd`
cp 1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate_resp2.mol2 /scratch/xu.jiam/sobtop
cd /scratch/xu.jiam/sobtop
cp $oldpath/vac_1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate.fch ./
cp $oldpath/sol_1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate.fch ./

./sobtop 1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate_resp2.mol2 << EOF
2

1
2
3
vac_1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate.fch

EOF

cp 1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate_resp2.gro $oldpath
cp 1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate_resp2.top $oldpath
cp 1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate_resp2.itp $oldpath

cd $oldpath

python itp_combin.py --i 1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate

module load openmpi/3.1.2
module load python/2.7.15
module load gromacs/2018.4-cpu
source /shared/centos7/gromacs/2018.4-cpu/bin/GMXRC

 
## if ! [ -f "ini_0.gro" ]; then
## mpirun -np 1 gmx_mpi insert-molecules -ci 1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate_resp2.gro -nmol 1200 -box 10 10 10 -o ini_0.gro
## 
## else
## mpirun -np 1 gmx_mpi insert-molecules -f ini_0.gro -ci 1_1_1_trifluoro_N__trifluoromethylsulfonyl_methanesulfonimidate_resp2.gro -nmol 1200 -box 10 10 10 -o ini.gro
## fi

