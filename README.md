# OrangeFox build script by SebaUbuntu

### A "simple" script that you can use to build OrangeFox Recovery Project without losing time exporting OF specific variables



### Features:

 - Build OrangeFox without losing time doing ". build/envsetup.sh" and "lunch codename" or changing manually release version

 - Help you with exporting OF specific variables

 - Organize device-specific variables in different files (called ofconfigs, similar to Linux defconfig), without touching the script

 - Generate device-specific variables step-by-step, helping you what to choose

 - When build is done, you can release file directly to a Telegram channel or group

### "How can I use it?"

 - Clone this repo to the root of OrangeFox sources

 - Give to scripts executing permissions

 - Create a file containing device-specific variables and put it in 
<pre><code>OF_ROOT/configs/CODENAME_ofconfig</code></pre>
Example for whyred: 
<pre><code>OF_ROOT/configs/whyred_ofconfig</code></pre>
See other ofconfigs for reference

 - Run the script with 
<pre><code>./orangefox_build.sh</code></pre>

### "How can I contribute to this repo?"

You can contribute by pull requesting ofconfigs to create a large database of config files, to help people that want to build OrangeFox for their devices without remaking them
