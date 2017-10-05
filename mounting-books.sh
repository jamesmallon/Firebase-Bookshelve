# Author: Thiago Mallon <thiagomallon@gmail.com>

# set variables to be used after
dirIn="/home/$USER/Calibre Library/"
dirOut="/home/$USER/Documents/Books/html-books/"
dirComm="./firebase/"

# transfer files
find "$dirIn" -iname '*.htmlz' -exec cp {} "$dirOut" \;

# extract files
find "$dirOut" -iname '*.htmlz' -exec sh -c 'unzip -d "${1%.*}" "$dirOut$1"' _ {} \;

# remove files
rm "$dirOut"*.htmlz

# add style directives
find "$dirOut" -iname '*.css' -exec sed -i '$ a body {background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), url("'"${dirOut}/earth.png"'") no-repeat fixed center; }' {} \;
find "$dirOut" -iname '*.css' -exec sed -i '$ a body, .calibre * { color: #0050d1; font-family: "Open Sans", Helvetica; font-weight: normal;}' {} \;
find "$dirOut" -iname '*.css' -exec sed -i '$ a a * {color: #138ec6; text-decoration: none; }' {} \;
find "$dirOut" -iname '*.css' -exec sed -i '$ a .calibre {  margin: 0 auto;  width: 32.5em; padding: 5em; background: rgba(0,0,0,0.5) !important; }' {} \;
find "$dirOut" -iname '*.css' -exec sed -i '$ a .jfk-bubble {background: gainsboro !important; }' {} \;
find "$dirOut" -iname '*.css' -exec sed -i '$ a ::-webkit-scrollbar {width: 2px;height: 2px;} ::-webkit-scrollbar-button {width: 0px;height: 0px;} ::-webkit-scrollbar-thumb {background: #00169a;border: 0px none #ffffff;border-radius: 50px;} ::-webkit-scrollbar-thumb:hover {background: #ffffff;} ::-webkit-scrollbar-thumb:active {background: #000000;} ::-webkit-scrollbar-track {background: #666666;border: 0px none #ffffff;border-radius: 50px;} ::-webkit-scrollbar-track:hover {background: #666666;} ::-webkit-scrollbar-track:active {background: #333333;} ::-webkit-scrollbar-corner {background: transparent;}' {} \;

# add bookshelve and images script
cp "${dirComm}/bookshelve.js" "$dirOut"
cp "${dirComm}/milkway.jpg" "$dirOut"
cp "${dirComm}/earth.png" "$dirOut"
cp "${dirComm}/favicon.png" "$dirOut"

# add scripts
find "$dirOut" -iname 'index.html' -exec sed -i '$ a <script src="https://www.gstatic.com/firebasejs/3.7.4/firebase.js"></script>' {} \;
find "$dirOut" -iname 'index.html' -exec sed -i '$ a <script type="text/javascript" src="../bookshelve.js"></script>' {} \;

# create index
dirOutIndex="${dirOut}index.html"

# tempĺateHtml=`cat ./firebase/html-template.html`
echo `cat ./firebase/html-template.html` >> "$dirOutIndex"

# cd "$dirOut"
declare -a dirs
i=1
for d in $dirOut*
# for d in $dirOut
do
	dirs[i++]="${d%/}"
done

for((i=1;i<=${#dirs[@]};i++))
do
	if [ "${dirs[i]}" != "${dirOut}bookshelve.js" ] &&
		[ "${dirs[i]}" != "${dirOut}index.html" ] &&
		[ "${dirs[i]}" != "${dirOut}favicon.png" ] &&
		[ "${dirs[i]}" != "${dirOut}milkway.jpg" ] &&
		[ "${dirs[i]}" != "${dirOut}earth.png" ] &&
		[ "${dirs[i]}" != "${dirOut}html-template.html" ]; then
		echo '<a href="'${dirs[i]}'/index.html"><img src="'${dirs[i]}'/cover.jpg" style="height: 10em; margin-left: 2em;"/></a>' >> "$dirOutIndex"
		echo -e "<link href='https://fonts.googleapis.com/css?family=Gentium+Book+Basic' rel='stylesheet'>\n"$(cat "${dirs[i]}/index.html") > "${dirs[i]}/index.html"
	fi
    # echo "${dirs[i]}"
done

echo "</body></html>" >> "$dirOutIndex"
