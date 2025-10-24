appName="$1"
version="$2"
revision="$3"
arch="$4"

if [ -z "${appName}" ] || [ -z "${version}" ] || [ -z "${revision}" ] || [ -z "${arch}" ]; then
    echo "Usage: ${0} <app name> <version> <revision> <arch>"
    exit 1
fi 

packageName="${appName}_${version}-${revision}_${arch}"

tmp=$(mktemp -d)

mkdir -p "${tmp}/${packageName}"
mkdir -p "${tmp}/${packageName}/bin"

exeSourcePath="bin/$(echo $arch | sed 's|amd64|x86_64|')/minit"
cp "${exeSourcePath}" "${tmp}/${packageName}/bin"

mkdir -p "${tmp}/${packageName}/DEBIAN"
controlFile="${tmp}/${packageName}/DEBIAN/control"

echo "Package: ${appName}" > $controlFile
echo "Version: ${version}" >> $controlFile
echo "Architecture: ${arch}" >> $controlFile
echo "Maintainer: PragmaticBench <office@pragmaticbench.com>" >> $controlFile
echo "Description: A very basic init program for containers to gracefully handle child process which are not correctly terminated by the application." >> $controlFile

dpkg-deb --build --root-owner-group "${tmp}/${packageName}"

mv "${tmp}/${packageName}.deb" bin

rm -rf $tmp