#makefile to build a wrf_io with ADIOS2

OBJSL   = wrf_io.o field_routines.o
OBJS    = $(OBJSL)
CODE    = ext_pnc_get_dom_ti.code \
	  ext_pnc_get_var_td.code \
	  ext_pnc_get_var_ti.code \
	  ext_pnc_put_dom_ti.code \
	  ext_pnc_put_var_td.code \
	  ext_pnc_put_var_ti.code \
	  transpose.code 
ADIOS2_INC = -I/mnt/central/spack/opt/spack/linux-centos8-cascadelake/gcc-10.2.0/adios2-2.6.0-eys5e6qf6vsrtgsumcvvftplbvwjmxrm/include/adios2/fortran
ADIOS2_LIBS = -Wl,-rpath,/mnt/central/spack/opt/spack/linux-centos8-cascadelake/gcc-10.2.0/adios2-2.6.0-eys5e6qf6vsrtgsumcvvftplbvwjmxrm/lib64 /mnt/central/spack/opt/spack/linux-centos8-cascadelake/gcc-10.2.0/adios2-2.6.0-eys5e6qf6vsrtgsumcvvftplbvwjmxrm/lib64/libadios2_fortran_mpi.so.2.6.0 /mnt/central/spack/opt/spack/linux-centos8-cascadelake/gcc-10.2.0/adios2-2.6.0-eys5e6qf6vsrtgsumcvvftplbvwjmxrm/lib64/libadios2_fortran.so.2.6.0 -Wl,-rpath-link,/mnt/central/spack/opt/spack/linux-centos8-cascadelake/gcc-10.2.0/adios2-2.6.0-eys5e6qf6vsrtgsumcvvftplbvwjmxrm/lib64
FFLAGS  = $(FCFLAGS) $(ADIOS2_INC) -I../ioapi_share
LIBS    = $(ADIOS2_LIBS)
CPP1    = $(CPP) -P $(TRADFLAG)
M4      = m4 -Uinclude -Uindex -Ulen
AR      = ar

.SUFFIXES:      .F90 .f .o .code

all : libwrfio_adios2.a 

libwrfio_adios2.a:		$(OBJS) $(CODE)
			/bin/rm -f libwrfio_adios2.a
			$(AR) cr libwrfio_adios2.a $(OBJSL)
			$(RANLIB) libwrfio_adios2.a

wrf_io.o:               wrf_io.F90 $(CODE)
			$(CPP1) $(ADIOS2_INC) $(ADIOS2_LIBS) -I../ioapi_share wrf_io.F90 | $(M4) - > wrf_io.f
			$(FC) $(FFLAGS) -c wrf_io.f

field_routines.o:	field_routines.F90 wrf_io.o
			$(CPP1) $(ADIOS2_INC) $(ADIOS2_LIBS) -I../ioapi_share field_routines.F90 > field_routines.f
			$(FC) $(FFLAGS) -c field_routines.f

superclean:
			@/bin/rm -f *.f *.o testWRFWrite testWRFRead \
			*.mod libwrfio_adios2.a
