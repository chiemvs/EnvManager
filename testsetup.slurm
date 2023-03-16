#!/usr/bin/bash
#SBATCH --job-name="venvtest"
#SBATCH --cpus-per-task=2
#SBATCH --time=01:00:00
#SBATCH --mem=5gb
#SBATCH --partition=ivm
#SBATCH --output=/scistor/ivm/jsn295/python_%j.out
#SBATCH --error=/scistor/ivm/jsn295/python_%j.err

module load 2022
module load Python

VENVNAME=TESTVENV

#$HOME/Documents/EnvManager/environment_setup.sh -c -j -t -s $VENVNAME
$HOME/Documents/EnvManager/environment_setup.sh -t -s $VENVNAME

module load CUDA/11.3.1 cuDNN/8.2.1.32-CUDA-11.3.1
source $TMPDIR/$VENVNAME/bin/activate
#source $HOME/$VENVNAME/bin/activate
which python3
python3 --version

python3 -c 'import cartopy'
python3 -c 'import torch; print(torch.cuda.is_available())'