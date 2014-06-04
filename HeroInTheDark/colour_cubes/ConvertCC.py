import sys, os, argparse, glob, re, tempfile, shutil

from klei import textureconverter, atlas, imgutil, util

def ExportColourCube(filename, out_path):
    path, base_name = os.path.split(filename)
    base_name, ext = os.path.splitext(base_name)
    path = os.path.abspath( path )

    if not os.path.exists( out_path ):
        os.makedirs( out_path )

    dest_filename = os.path.join(out_path, base_name+".tex")
    textureconverter.Convert(
            src_filenames=filename, dest_filename=dest_filename,
            platform=args.platform,
            texture_format="rgb",#args.textureformat,
            force=args.force,
            ignore_exceptions=args.ignoreexceptions )

parser = argparse.ArgumentParser( description = "Animation batch exporter script" )
parser.add_argument( '--textureformat', default='bc3' )
parser.add_argument( '--platform', default='opengl' )
parser.add_argument( '--force', action='store_true' )
parser.add_argument( '--hardalphatextureformat', default='bc1' )
parser.add_argument( '--square', action='store_true' )
parser.add_argument( 'images', type=str, nargs='*' )
parser.add_argument( '--ignoreexceptions', action='store_true' )
parser.add_argument( '--outputdir', default='' )
args = parser.parse_args()


for image in glob.glob( "*.png" ):
    print("Exporting "+image)
    ExportColourCube(image, os.getcwd())
