# EnvManager

Reproducable creation of virtual environments
at the BAZIS cluster of VU Amsterdam
[link](https://bazis.readthedocs.io/en/latest/)

Uses the latest Python version available in 2022 stack

For usage:
./environment\_setup.sh -h 

Optional support besides basic packages:
- jupyter notebooks
- pytorch (CUDA enabled)
- cartopy

testsetup.slurm is for testing purposes

TODO: make sure lines are added to VENVNAME/bin/activate
such that the right module are also loaded upon activation
of the new environment.
