#!/bin/sh

to_irc(){
  oldrev=$(git rev-parse $1)
  oldrevshort=$(git log -1 --format="%h" $oldrev)
  newrev=$(git rev-parse $2)
  newrevshort=$(git log -1 --format="%h" $newrev)

  commitcount=$(git log --format="%h" ${oldrev}..${newrev} | wc -l)
  shortstats=$(git diff --shortstat ${oldrev}..${newrev})
  authors=$(git log --format="%aN" ${oldrev}..${newrev} | sort | uniq | sed ':a;N;$!ba;s/\n/, /g')

  maxcount=6

  nick=$(hostname -s)
  chan="#c2c-sysadmin"
  server="hivane.geeknode.org"
  port="6667"
  user=$(whoami)

  (
    echo "NICK ${nick}"
    echo "USER ${nick} 0 * :Gecos"
    echo "JOIN ${chan}"
    if [ $commitcount -gt $maxcount ]; then
      echo "PRIVMSG ${chan} :${user} pushed ${commitcount} commits from ${authors} to ${3}"
      echo "PRIVMSG ${chan} :${shortstats}"
      echo "PRIVMSG ${chan} :for details: git log -p ${oldrevshort}..${newrevshort}"
    else
      echo "PRIVMSG ${chan} :${user} pushed ${commitcount} commits to ${3} - ${oldrevshort}..${newrevshort}"
      echo "PRIVMSG ${chan} :${shortstats}"
      for commit in $(git log --format="%h" ${oldrev}..${newrev}); do
        oneline=$(git log -1 --format="%h - %s (%an)" $commit)
        echo "PRIVMSG ${chan} :${oneline}"
      done
    fi
    echo "QUIT"
  ) | nc $server $port | logger -t 'git-irc-hook'
}

while read oldrev newrev refname; do
  project=$(pwd)
  project=${project%.git}

  if expr "$oldrev" : '0*$' >/dev/null; then
    exit 0
  elif expr "$newrev" : '0*$' >/dev/null; then
    exit 0
  else
    to_irc $oldrev $newrev $project
  fi
done
