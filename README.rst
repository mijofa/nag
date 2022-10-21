Initial documentation notes (not tested or anything yet):

This is just for nag2al currently, not the nag code on your laptop

#. on heavy.cyber.com.au::

       git clone https://github.com/mijofa/nag ~/nag
       cd ~/nag
       systemctl --user link $PWD/alloc-timesheet-bullshit-hourly.service
       systemctl --user link $PWD/alloc-timesheet-bullshit-hourly.timer
       systemctl --user link $PWD/alloc-timesheet-bullshit-monthly.service
       systemctl --user link $PWD/alloc-timesheet-bullshit-monthly.timer
       systemctl --user link $PWD/nag2al.service
       systemctl --user link $PWD/nag2al.timer
       systemctl --user enable --now alloc-timesheet-bullshit-monthly.timer
       systemctl --user enable --now alloc-timesheet-bullshit-hourly.timer
       systemctl --user enable --now nag2al.timer
       mkdir -p ~/.local/bin/
       ln -s $PWD/alloc-timesheet-bullshit.py ~/.local/bin/alloc-timesheet-bullshit
       ln -s $PWD/nag2al.sh                   ~/.local/bin/nag2al
       ln -s $PWD/nag2al-wrapper.sh           ~/.local/bin/nag2al-wrapper

       git init --bare ~/.nag.git

#. On laptop::

       git -C ~/.nag remote set-url origin heavy.cyber.com.au:.nag
       git -C ~/.nag push

#. On flora, remove the relevant crontab entries.
   I commented out these::

       # ## Process nag timelog into Alloc timesheet items
       # 07 03    * * *     git --git-dir "$HOME/.nag.git/" show master:timelog | grep "$(date +'^\%F ' --date 'Yesterday')" | /home/mike/bin/nag2al -v
       #
       # ### Push timesheets
       # ## Longer than 7 hours or older than 7 days
       # 05 03    * * *     { alloc timesheets -sedit -h'>=7' | sed 1d ; alloc timesheets -sedit -d"<=$(date -I -d '1 week ago')" | sed 1d ; } | sort -u | alloc submit
       # ## All timesheets every Monday morning
       # 05 05    * * mon   alloc timesheets | sed 1d | alloc submit
       # ## All timesheets on the first of every month (including financial year)
       # 05 07    1 * *     alloc timesheets | sed 1d | alloc submit
       # ### All timesheets end of every financial year
       # #05 09    1 7 *     alloc timesheets | sed 1d | alloc submit
