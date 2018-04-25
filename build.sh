#! /bin/sh -e
LINE_SCRIPT=./get_plugin_line.sh
CADDY_SRC_PATH="src/github.com/mholt/caddy"
CADDY_VERSION="v0.10.14"
RUN_GO="$CADDY_SRC_PATH/caddy/caddymain/run.go"
CWD=$(pwd)

echo "remove possible leftovers"
rm -rf ./pkg || true
rm -rf ./src || true
rm -rf ./build || true

echo "create src path for our go environment"
mkdir ./src

echo "create build output path"
mkdir ./build

echo "get caddy"
git clone https://github.com/mholt/caddy $CADDY_SRC_PATH
cd $CADDY_SRC_PATH
git checkout $CADDY_VERSION
cd $CWD

echo "\n\nadd plugin imports to run.go"
IMPORT_LINE=$(sh $LINE_SCRIPT $RUN_GO)
NEXT_LINE=$(expr $IMPORT_LINE + 1)
head -n $IMPORT_LINE $RUN_GO > $RUN_GO.new
cat plugins.txt | while read -r a; do echo "\t_ \"$a\"" >> $RUN_GO.new; done
tail -n +$NEXT_LINE $RUN_GO >> $RUN_GO.new
rm $RUN_GO
mv $RUN_GO.new $RUN_GO

echo "use a local go environment"
export GOPATH=$(pwd)

echo "\nget plugins"
cat plugins.txt | while read -r a; do echo "getting $a"; go get $a; done

echo "\nget caddy build helper"
go get github.com/caddyserver/builds

echo "build"
cd $CADDY_SRC_PATH/caddy
echo "linux"
go run build.go -goos=linux -goarch=amd64
mv caddy $CWD/build/caddy_linux
echo "darwin"
go run build.go -goos=darwin -goarch=amd64
mv caddy $CWD/build/caddy_darwin
echo "windows"
go run build.go -goos=windows -goarch=amd64
mv caddy.exe $CWD/build/caddy_windows.exe

echo "\nbuild finished. have a look at ./build"