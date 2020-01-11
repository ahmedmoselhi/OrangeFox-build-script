# OrangeFox build script by SebaUbuntu

## A simple script that you can use to build OrangeFox Recovery Project without losing time exporting OF specific variables

### "How can I use it?"

You will need to create a file containing device-specific variables, then script will automatically grab this file and pick variables

This file need to be located in <pre><code>OF_ROOT/configs/CODENAME.ofconf</code></pre>

Example for whyred: <pre><code>OF_ROOT/configs/whyred.ofconf</code></pre>

For creating this file, you can use as example some ofconf already in this repo

Using this method is useful if you don't want to edit script or if you don't know Bash

### "I made a ofconf for my device"

Good, if you want you can pull request the file to create a large database of config files, to help people that want to build OrangeFox for their devices
