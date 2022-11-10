#! /bin/sh

rm -r ./.git
rm README.md
touch README.md
git init
cd ../
rm ./git_reload.sh
mv ./special-umbrella ./prog

