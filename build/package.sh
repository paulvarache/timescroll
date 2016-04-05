#!/bin/sh

# check you are running the build script from the build/ folder
current_pwd=`pwd`
current_dir=`basename $current_pwd`
if [ $current_dir != 'build' ]; then
    echo 'You must be in the build folder to run the script!'
    exit 1
fi


# parsing args
RUN=0
SEND=""

for i in "$@"
do
case $i in
    # Run the game after the build
    -r*|--run*)
        RUN=1
        shift
    ;;
    *)
    # unknown option
    ;;
esac
done

echo 'deleting Mac OS .DS_Store files..'
find .. -name .DS_Store -delete

echo 'creating temp folder..'
mkdir -p temp

echo 'copying source files..'
cp -r ../src/* temp/

echo 'copying resources..'
rsync -r --exclude=*.tmx,*.psd ../res temp/

echo 'packaging everything into .love file..'
cd temp
zip -9 -q -r timescroll.love .

echo 'moving build into bin folder..'
mkdir -p ../../bin
mv timescroll.love ../../bin/
cd ../

echo 'removing temp folder..'
rm -rf temp

if [ $RUN -eq 1 ]; then
    echo 'launching the game..'
    love ../bin/timescroll.love $*
fi
