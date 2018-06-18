# InstallerGenerator

##Usage:

1. put all the files you want to package in `source/payload`
2. optionally modify/remove `source/bootstrap.rb` ; it's a hook that's automatically executed (if present) after unpacking. The absolute payload path is passed to it as an argument.
Removing it will cause JRuby not to be used, bringing a ~20MB reduction in the self-extracting archive size.
3. run `create_unpacker.sh` ; now you have in `packed` your self-extracting archive. You can rename it and move it wherever you want.
4. Execute your self-extracting archive. It will unpack its content in the `unpacked/payload` folder wherever the script is. If `bootstrap.rb` is present, it will then be launched and removed (along with the JRuby binaries used to launch it).
