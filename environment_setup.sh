#!/bin/bash

Help()
{
   # Display Help
   echo "Setting up virtual environment based on"
   echo "2022 module stack and python 3.10."
   echo "Defaults to building \$HOME/<VENVNAME>."
   echo
   echo "Syntax: setup_environment.sh [-s|j|t|c|h] VENVNAME"
   echo "options:"
   echo "s     Setup the environment in \$TMPDIR (usually scratch)."
   echo "j     Include jupyter support."
   echo "t     Include tensorflow support (2.9.0)."
   echo "p     Include pytorch support (1.12.1)."
   echo "c     Include cartopy support."
   echo "h     Print this Help."
   echo
}

WORKDIR=$HOME
SUPJUP=false
SUPTEN=false
SUPTOR=false
SUPCAR=false

while getopts ":sjtpch" option; do
    case $option in
        h)
            Help
            exit;;
        s)
            WORKDIR=$TMPDIR;;
        j)
            SUPJUP=true;;
        t)
            SUPTEN=true;;
        p)
            SUPTOR=true;;
        c)
            SUPCAR=true;;
        \?)
            echo "Error: Invalid option"
            exit;;
    esac
done

# Trick from https://www.howtogeek.com/778410/how-to-use-getopts-to-parse-linux-shell-script-options/
shift "$(($OPTIND -1))"

VENVNAME=$1
MODULES='2022 Python'
module load $MODULES

VENVPATH=${WORKDIR}/${VENVNAME}
echo "seting up in:"
echo $VENVPATH

python3 --version
python3 -m venv $VENVPATH
source ${VENVPATH}/bin/activate # Does not have effect when script ends
pip3 install --upgrade pip
pip3 install wheel
pip3 install -r $HOME/Documents/EnvManager/basic_venv_requirements.txt

# If with torch support
if [ "$SUPTOR" = true ] ; then
    echo "including pytorch support"
    #module load CUDA/11.7.0 cuDNN/8.4.1.50-CUDA-11.7.0
    #pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu117
    #pip3 install pyg_lib torch_scatter torch_sparse torch_cluster torch_spline_conv torch_geometric -f https://data.pyg.org/whl/torch-1.13.0+cu117.html
    ## Or if CUDA still 11.3:
    EXTRAMODULES='CUDA/11.3.1 cuDNN/8.2.1.32-CUDA-11.3.1'
    MODULES="${MODULES} ${EXTRAMODULES}"
    module load $EXTRAMODULES
    pip3 install torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu113
    pip3 install torch_geometric
    # Optional dependencies, uncomment if needed
    #pip3 install pyg_lib torch_scatter torch_sparse torch_cluster torch_spline_conv -f https://data.pyg.org/whl/torch-1.12.1+cu113.html
fi

# If with tensorflow
if [ "$SUPTEN" = true ] ; then
    echo "including tensorflow support"
    if [ "$SUPTOR" = false ] ; then
        # If it were true then these modules have been already laded
        EXTRAMODULES='CUDA/11.3.1 cuDNN/8.2.1.32-CUDA-11.3.1'
        MODULES="${MODULES} ${EXTRAMODULES}"
        module load $EXTRAMODULES
    fi
    pip3 install tensorflow==2.9.0
fi

# If with jupyter
if [ "$SUPJUP" = true ] ; then
    echo "including jupyter support"
    pip3 install notebook
fi

# If with cartopy
if [ "$SUPCAR" = true ] ; then
    echo "including cartopy support"
    EXTRAMODULES='GEOS/3.9.1-GCC-11.2.0'
    MODULES="${MODULES} ${EXTRAMODULES}"
    module load $EXTRAMODULES
    pip3 install --upgrade pyshp
    pip3 install "shapely<2" --no-binary shapely
    pip3 install cartopy
fi

# Adding automatic module loading at 4th line of the activate script
# Saves a backup .bak
sed -i.bak "4i\
module load ${MODULES}\
" ${VENVPATH}/bin/activate
