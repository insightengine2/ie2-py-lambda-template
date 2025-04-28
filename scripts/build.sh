#!/bin/bash
cd ..

BUILDDIR="build"
DEPSDIR="deps"
FILENAME="bootstrap.zip"
REQSFILENAME="requirements.txt"
DISTDIR="dist"
RUNTIMEARCH="manylinux2014_aarch64"
PYTHONVER="3.13.3"

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

# copy source code to build directory
cp -r ./src ./$BUILDDIR

cd $BUILDDIR

# add source files to zip archive
zip -r "../$DISTDIR/$FILENAME" "."

# prepare a deps directory
mkdir ./$DEPSDIR

# install requirements generator tool
pip install pipreqs

# generate requirements.txt
pipreqs . --force --ignore=tests

# check if requirements file is empty first
if [ -e $REQSFILENAME ] && [ ! -s $REQSFILENAME ]; then
    echo "$REQSFILENAME exists AND is empty..."
    echo "Skipping dependencies install."
else
    # install dependencies to deps directory
    pip install --platform $RUNTIMEARCH --python-version $PYTHONVER --only-binary=:all: --target ./$DEPSDIR -r $REQSFILENAME

    # check if any dependencies were downloaded
    # find "./$DEPSDIR/" -maxdepth 0 -empty | read v
    filecnt=$(ls -A "./$DEPSDIR" | wc -l)
    echo "Found $filecnt files!"
    if [ $filecnt -gt 0 ]; then
        echo "Dependencies found. Updating archive..."
        cd $DEPSDIR
        zip -ur "../../$DISTDIR/$FILENAME" "."
        cd ..
    else
        echo "No dependencies found in $DEPSDIR."
    fi
fi

echo "Build Complete"

cd ../$DISTDIR

if [ -f "./$FILENAME" ]; then
    filesize=$(wc --bytes "./$FILENAME")
    echo "Wrote $filesize"
else 
    echo "...but unable to find $FILENAME!"
fi