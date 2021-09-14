#Compile WRF-hydro on Stampede2
#09142021 Wen-Ying Wu

module load netcdf/4.6.2
module save 
# go to .bashrc to add
 #added for NWM 5.1.1
export NETCDF_INC="/opt/apps/intel18/netcdf/4.6.2/x86_64/include"
export NETCDF_LIB="/opt/apps/intel18/netcdf/4.6.2/x86_64/lib"

source .bashrc
------/close terminal/-----
-----/nevigate to work/-----------

idev -m 60 -A A-go3

# Donwnload the model code
wget https://github.com/NCAR/wrf_hydro_nwm_public/archive/v5.1.1.tar.gz
v5.1.1.tar.gztar -xf  

cd wrf_hydro_nwm_public-5.1.1/trunk/NDHMS
cp template/setEnvar.sh .

./configure
#chose 3
./compile_offline_NoahMP.sh setEnvar.sh

*****************************************************************
Make was successful

*****************************************************************
The environment variables used in the compile:
HYDRO_D=1
NCEP_WCOSS=0
NETCDF=
SPATIAL_SOIL=1
WRF_HYDRO=1
WRF_HYDRO_NUDGING=1
WRF_HYDRO_RAPID=0



Check ./Run



wget https://github.com/NCAR/wrf_hydro_nwm_public/releases/download/v5.1.2/croton_NY_example_testcase.tar.gz
tar -xf croton_NY_example_testcase.tar.gz 
mkdir domain
cp -r ./example_case/ ./domain/croton_NY
cp wrf_hydro_nwm_public-5.1.1/trunk/NDHMS/Run/*.TBL domain/croton_NY/NWM
cp wrf_hydro_nwm_public-5.1.1/trunk/NDHMS/Run/wrf_hydro.exe domain/croton_NY/NWM
cd domain/croton_NY/NWM
cp -r ../FORCING .

#vim namelist 
#to KHOUR=8
./wrf_hydro.exe
