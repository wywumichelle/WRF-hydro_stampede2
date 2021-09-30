# Install WRF-hydro on TACC Stampede2 
# and Run a test case
09142021 Wen-Ying Wu
## 1. Set up the environment
Load the latest NetCDF package.
```
module load netcdf/4.6.2
module save 
```
Add commands in ~/.bashrc

```
#added for WRF-hydro 5.1.1
export NETCDF_INC="/opt/apps/intel18/netcdf/4.6.2/x86_64/include"
export NETCDF_LIB="/opt/apps/intel18/netcdf/4.6.2/x86_64/lib"
```
Restart the terminal or 
```
source .bashrc
```

### 2. Download the latest WRF-hydro 
Recommend to put the model source code in $WORK or $HOME directory.
Recommend Finish following steps on a computational node

```
cdw
idev -m 60
mkdir model
cd model
```

Donwnload the model source code
```
wget https://github.com/NCAR/wrf_hydro_nwm_public/archive/v5.1.1.tar.gz
```
Extract the tar.gz. 
```
tar -xf v5.1.1.tar.gz
```
You will see a new wrf_hydro_nwm_* folder

### 3. Configure and Compile the model
```
cd wrf_hydro_nwm_public-5.1.1/trunk/NDHMS
cp template/setEnvar.sh .
```
Modify setEnvar.sh if needed
Here is the setting I use for a test case
```
HYDRO_D=1
NCEP_WCOSS=0
SPATIAL_SOIL=1
WRF_HYDRO=1
WRF_HYDRO_NUDGING=1
WRF_HYDRO_RAPID=0
```
Configure the model. Choose option 3 (ifort)
```
./configure 3
```
Compile the model based on setting.
```
./compile_offline_NoahMP.sh setEnvar.sh
```
If make sucessful you will see

> *****************************************************************
> Make was successful
> 
> *****************************************************************

And there will be a new directory ./Run, in which you will find wrf_hydro.exe and *.TBL.

### 4. Run a test case
Recommend to put it in $SCRATCH or $WORK
#### Download the test case from NCAR
TAll files needed to run a test case for Croton New York

```
wget https://github.com/NCAR/wrf_hydro_nwm_public/releases/download/v5.1.2/croton_NY_example_testcase.tar.gz
tar -xf croton_NY_example_testcase.tar.gz 
```
There willl ba new directory called "example_case".
### Prepare the directory and files

```
mkdir domain
cp -r ./example_case/ ./domain/croton_NY
```
### Copy the an essential files that we just compiled.
```
cp $WORK/model/wrf_hydro_nwm_public-5.1.1/trunk/NDHMS/Run/*.TBL domain/croton_NY/NWM
cp $WORK/model/wrf_hydro_nwm_public-5.1.1/trunk/NDHMS/Run/wrf_hydro.exe domain/croton_NY/NWM
```
Go the directory where we are going to run the model.
```
cd domain/croton_NY/NWM
```
There is one directory that have to be moved or copied. Or you can modifiled its path in namelist.hrldas
```
cp -r ../FORCING .
```
You can modifed simulation time shorter in namelist.hrldas
e.g.,
> KHOUR=8

### Run the model!
```
./wrf_hydro.exe
```
### Play with the outout data!



## Reference and Acknowledgement

Intructions at this page follow the guide provided NCAR

#### Techinal Guide for WRF-hydro by NCAR https://ral.ucar.edu/sites/default/files/public/projects/Technical%20Description%20%26amp%3B%20User%20Guides/howtobuildrunwrfhydrov511instandalonemode.pdf

#### Guid fo the croton_NY test case by NAR https://ral.ucar.edu/sites/default/files/public/WRF-HydroV5TestCaseUserGuide_3.pdf
