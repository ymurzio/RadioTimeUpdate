#update time

#sudo check
sudo ls &> /dev/null

#get latest time differentials
cd ~/.local/share/WSJT-X
differentialIndex=$(tail ALL.TXT | sed -e 's/  */ /g' | sed -e '/Tx/d' | cut -d ' ' -f 6 | sort -n | echo "$(wc -l)/2" | bc)
timeDifferential=$(tail ALL.TXT | sed -e 's/  */ /g' | sed -e '/Tx/d' | cut -d ' ' -f 6 | sort -n | sed -ne "$differentialIndex"p)

#get current time
currentTime=$(timedatectl | grep -e 'Local time' | cut -d ' ' -f 19,20)
currentUnix=$(date --date="$currentTime" +"%s")

#calculate new time
newUnix=$(echo "$currentUnix-($timeDifferential)" | bc)
newTime=$(date -d @$newUnix +%F\ %H:%M:%d.%N | sed -e 's/0*$//g')

#set new time
sudo date -s @$newUnix
