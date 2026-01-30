#!/bin/bash

BUILDDIR="build"
FILENAME="bootstrap.zip"
REQSFILENAME="requirements.txt"
DISTDIR="dist"
PYTHONVER="3.14"
VENVDIR=".venv"

# remove remnants of previous builds
if [ -d $BUILDDIR ]; then
    echo "$BUILDDIR exists!"
    echo "Preparing to delete $BUILDIR"
    rm -r $BUILDDIR/
fi

if [ -d $DISTDIR ]; then
    echo "$DISTDIR exists!"
    echo "Preparing to delete $DISTDIR"
    rm -r $DISTDIR/
fi

mkdir $DISTDIR

# create a virtual env dir and activate it
$("python$PYTHONVER" -m venv ./$VENVDIR)

source ./$VENVDIR/bin/activate

# copy source code to build directory
cp -r ./src ./$BUILDDIR

cd ./$BUILDDIR

# generate a requirements file
pip3 freeze > $REQSFILENAME

pip3 install -r $REQSFILENAME --target .

# delete six.py which probably was created
rm ./six.py

# add source files to zip archive
zip -r "../$DISTDIR/$FILENAME" "."

# deactivate the venv
deactivate

echo "Build Complete"

cd ../$DISTDIR

if [ -f "./$FILENAME" ]; then
  filesize=$(wc -c "./$FILENAME" | awk '{print $1}')
  echo "Wrote $filesize bytes"
else 
  echo "...but unable to find $FILENAME!"
fi

cd ..
