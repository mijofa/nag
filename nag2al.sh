#!/bin/bash -eEu
trap 'echo >&2 "$0: unknown error"' ERR

maybe_dry_run(){ printf "%s %s %s %s %s %q\n" "$@";}
non_tasks_only=0
while getopts "nfvi" opt
do  case "$opt" in
        n) maybe_dry_run(){ printf "%s %s %s %s %s %q\n" "$@";};;
        f) maybe_dry_run(){ "$@";};;
        v) maybe_dry_run(){ printf "%s %s %s %s %s %q\n" "$@"; "$@";};;
        i) non_tasks_only=1;;
        '?') exit 1;;
    esac
done
shift $((${OPTIND:-1}-1))

day1= time1= task1= comment1=
while read day time task comment
do
    [[ $task =~ ^[[:digit:]]+$ ]] ||
    comment="$task${comment:+ $comment}" task=?????
#    comment="${comment%%#*}"
    comment="${comment%% }"

    # Truncate to the zeroth second.  This prevents the period
    # 10:00:00 to 10:15:01 being rounded up to a half-hour.
    time="${time%:??[+-]??:??}:00${time#??:??:??}"

    # Unless the task/comment has changed, this isn't a "real" edge,
    # so proceed on to the next one (without setting the foo1 old
    # flavours).
    test "$task1$comment1" != "$task$comment" || continue

    if test -n "$day1"         # we've seen at least one entry before.
    then
        dur=$((($(date -d"$day $time" +%s) - $(date -d"$day1 $time1" +%s))))
        dur=$(((dur/900) + !!(dur%900)))                  # round to nearest 15min
#        regex="^(email|food|home|fnord.*)$"
        if test $non_tasks_only -eq 0
        then
          # Only show valid tasks
#          [[ $comment1 =~ $regex || $task1 = 0* ]] || # skip boring entries
          maybe_dry_run alloc work -qt"$task1" -d"$day1" -h"$((dur*15))m" \
            "-c${comment1:-NO COMMENT} [${time1%?????????}]" || :
        else
          # Only show invalid tasks
#          [[ $comment1 =~ $regex || $task1 = 0* ]] && # show only boring entries
          maybe_dry_run alloc work -qt"$task1" -d"$day1" -h"$((dur*15))m" \
            "-c${comment1:-NO COMMENT} [${time1%?????????}]" || :
        fi
        if [ "$((dur*15))" = 0 ] ; then
            echo "!!! WARNING: ^ that's a 0m length line item" >&2
        fi
    fi
    day1=$day time1=$time task1=$task comment1=$comment
done < <(cat "$@" | sort)
