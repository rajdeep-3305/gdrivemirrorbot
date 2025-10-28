
#!/bin/sh
set -e

display_usage() {
  echo "Downloads a single file from SourceForge."
  echo -e "\nUsage: ./sourceforge-single-download.sh [file link]\n"
  echo "Example: ./sourceforge-single-download.sh https://sourceforge.net/projects/myproject/files/folder/filename.zip/download"
}

if [ $# -lt 1 ]
then
  display_usage
  exit 1
fi

file_url=$1
echo "Downloading from $file_url"

# extract project and filepath from the URL
project=$(echo "$file_url" | sed 's#.*projects/\([^/]*\)/files.*#\1#')
filepath=$(echo "$file_url" | sed 's#.*files/\(.*\)/download.*#\1#')

# construct the direct download URL
url="https://master.dl.sourceforge.net/project/${project}/${filepath}?viasf=1"

# download the file with content-disposition to preserve original filename
wget --content-disposition "${url}"

# remove ?viasf=1 suffix from downloaded filename if it exists
find . -maxdepth 1 -name '*?viasf=1' -print0 | xargs -0 -r rename --verbose "?viasf=1" ""

echo "Download complete"
