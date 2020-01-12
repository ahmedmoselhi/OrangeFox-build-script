# OrangeFox build script by SebaUbuntu

## A "simple" (XD) script that you can use to build OrangeFox Recovery Project without losing time exporting OF specific variables

### "How can I use it?"

 - Download scripts and configs folder to root of OrangeFox sources

 - Give to scripts executing permissions

 - Create a file containing device-specific variables and put it in <pre><code>OF_ROOT/configs/CODENAME_ofconfig</code></pre>
Example for whyred: <pre><code>OF_ROOT/configs/whyred_ofconfig</code></pre>
See other ofconfigs for reference

 - Run the script with <pre><code> ./orangefox_build.sh </code></pre>

### "I made a ofconf for my device"

Good, if you want you can pull request the file to create a large database of config files, to help people that want to build OrangeFox for their devices
