# EnvManager

Reproducable creation of virtual environments
at the BAZIS cluster of VU Amsterdam
[link](https://bazis.readthedocs.io/en/latest/)

Builds on: python3 -m venv

in combination with: pip3 

for package management

Employs the latest Python version available in 2022 module stack

For usage:
./environment\_setup.sh -h 

Optional support besides basic packages:
- jupyter notebooks
- pytorch (CUDA enabled)
- cartopy

Keeps a record of the required modules
and adds those as a load statement in the 
first lines of VENVNAME/bin/activate
Correct modules should therefore automatically load 
upon activation

testsetup.slurm is for testing purposes
