#!/usr/bin/fish
for user in (users | string split ' ' | sort | uniq)
    runuser --user={$user} -- systemctl start --user 'pacman-update_notifier_'{$argv}'.service'
    echo 'Started notification'{$user}
end
