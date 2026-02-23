#!/usr/bin/fish

for operation in 'refresh' 'sysupgrade'
	if systemctl --quiet is-failed 'pacman-update@'{$operation}'.service'
		set --function --append failures {$operation}
	end
end


# Configuration
## Individual
if set -qf failures
	set --function actions 'logs=Show Logs'
	set --function title "$failures"
else
	echo 'No failures'
	return 1
end

if path is --type=file /var/lib/pacman/db.lck # Overwrites
	set --function actions 'unlock_and_retry=Unlock & Retry'
	set --function title 'Locked Database'
end

## Common
if set -qf 'actions'
	set --function actions '--action='{$actions}
end
if set -qf 'title'
	set --function title 'Update failed: '"$title"
end


notify-send --icon='system-software-update' --app-name='System Update' --urgency=critical {$title} {$actions} | read --function 'response'


# Actions
switch {$response}
	case 'logs'
		echo 'Showing logs'
		kgx --title='Logs: '"$failures" --command='journalctl --this-boot --since=-1h30min --unit=pacman-update@'"$failures"'.service'
	case 'unlock_and_retry'
		echo 'Unlocking database'
		systemctl start pacman-update_unlock-database.service

		echo 'Retrying update'
		systemctl start pacman-update.target
	case *
		echo 'Action not taken'
end

