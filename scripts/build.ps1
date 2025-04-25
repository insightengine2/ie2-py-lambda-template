
cd ..

$BUILDDIR="build"
$DEPSDIR="deps"
$FILENAME="bootstrap.zip"
$REQSFILENAME="requirements.txt"
$DISTDIR="dist"
$RUNTIMEARCH="manylinux2014_aarch64"
$PYTHONVER="3.13.3"

# remove remnants of previous builds
rm -r $BUILDDIR/
rm -r $DISTDIR/

mkdir $DISTDIR

# copy source code to build directory
cp -r ./src ./$BUILDDIR

cd $BUILDDIR

# add source files to zip archive
Compress-Archive -DestinationPath "../$DISTDIR/$FILENAME" -Force -Path "./*"

# # prepare a deps directory
mkdir ./$DEPSDIR

# # install requirements generator tool
pip install pipreqs

# # generate requirements.txt
pipreqs . --force --ignore=tests

# check if requirements file is empty first
$reqs = Get-Content "./$REQSFILENAME" -Raw


if ([string]::IsNullOrWhiteSpace($reqs)) {
    Write-Host "Requirements file is empty. Skipping dependencies install."
} else {

    # install dependencies to deps directory
    pip install --platform $RUNTIMEARCH --python-version $PYTHONVER --only-binary=:all: --target ./$DEPSDIR -r $REQSFILENAME

    if (Test-Path .) {
        Write-Host "Dependencies found. Updating archive..."
        Compress-Archive -DestinationPath "../$DISTDIR/$FILENAME" -Update -Path "./$DEPSDIR/*" 
    } else {
        Write-Host "No dependencies found in $DISTDIR."
    }
}

Write-Host "Build Complete"

cd ../$DISTDIR

if (Test-Path "$FILENAME") {

    $filesize = (Get-Item "$FILENAME").Length
    Write-Host "Wrote $filesize bytes to $FILENAME"
} else {
    Write-Host "...but unable to find $FILENAME!"
}
