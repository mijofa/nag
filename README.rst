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
