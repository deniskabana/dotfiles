echo "\033[0;33mRequesting admin rights\033[0m\n"
sudo echo > /dev/null

echo "\033[0;33mDeleting temp file from before\033[0m\n"
rm tempBootableOS.img.dmg 2>/dev/null

echo "\033[0;33mConverting $( basename $2 ) to dmg temp file\033[0m\n"
hdiutil convert -format UDRW -o tempBootableOS.img.dmg $2

echo "\033[0;33mEcho unmounting disk $1\033[0m\n"
diskutil unmountDisk $1

echo "\033[0;33mWriting new disk image to USB - takes around 10 min.\033[0m\n(Press ^t to check on progress...)\n\n"
sudo dd if=tempBootableOS.img.dmg of=$1 bs=1m

echo "\033[0;33mDeleting temp file\033[0m\n"
rm tempBootableOS.img.dmg

echo "\033[0;33mEjecting $1\033[0m\n"
diskutil eject $1
