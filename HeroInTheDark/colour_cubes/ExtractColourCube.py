import sys, os, pprint
from PIL import Image

from ColourCube import CUBE_DIMENSION

if __name__ == "__main__":
    print sys.argv

    if len( sys.argv ) != 2:
        print "\nSpecify an input filename"
        sys.exit( 255 )

    filename = sys.argv[ 1 ]

    image = Image.open( filename )
    image = image.crop( ( 0, image.size[1] - CUBE_DIMENSION,
                          CUBE_DIMENSION * CUBE_DIMENSION, image.size[1] ) )

    new_filename, ext = os.path.splitext( filename )
    new_filename += "_cc.png"

    image.save( new_filename )

