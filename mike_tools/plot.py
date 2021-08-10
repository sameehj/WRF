import argparse
import adios2                               # pylint: disable=import-error
import numpy as np                          # pylint: disable=import-error
import matplotlib.pyplot as plt             # pylint: disable=import-error
import matplotlib.gridspec as gridspec      # pylint: disable=import-error
from mpi4py import MPI                               # pylint: disable=import-error

def setup_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--instream", "-i", help="Name of the input stream", default="wrfout_d01_2018-06-17_00:00:00")
    parser.add_argument("--outfile", "-o", help="Name of the output file", default="screen")
    parser.add_argument("--varname", "-v", help="Name of variable read", default="T2")
    args = parser.parse_args()
    return args

def plot_var(var, fr_step, args):
    displaysec = 0.5
    cur_step = fr_step.current_step()
    
    x = fr_step.read("XLAT")
    y = fr_step.read("XLONG")
    data = fr_step.read(var)
    plt.contourf(x, y, data, 40, cmap='RdGy')
    plt.colorbar();

    plt.ion()
    if (args.outfile == "screen"):
        plt.show()
        plt.pause(displaysec)
    else:
        imgfile = args.outfile+"{0:0>5}.png".format(cur_step)
        plt.savefig(imgfile)
    plt.clf()

if __name__ == "__main__":
    args = setup_args()
    fr = adios2.open(args.instream, "r", MPI.COMM_WORLD, "adios2.xml", args.instream)

    for fr_step in fr:
        plot_var(args.varname, fr_step, args)

    fr.close()
