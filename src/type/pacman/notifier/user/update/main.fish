#!/usr/bin/fish
set --local new_packages (pacman -Quq)
if test -z "$new_packages"
	echo 'No new packages found'
	return 0
end

if ! test -z "$(pacman -Qc "$new_packages" 2> /dev/null)"
	echo 'Changelog of atleast 1 package was found'
	set --function changelog_action '--action=changelog=Show Change-log'
end

if test (count {$new_packages}) -gt 1
	set --function package_message_tense 's'
end

notify-send --icon='system-software-update' --app-name='System Update' --urgency=low --wait {$changelog_action} 'Upgrading '(count {$new_packages})' package'"$package_message_tense" "$new_packages" | read --global --nchars=9 'changelog_response' || true

if test "$changelog_response" = 'changelog'
	kgx --title='Change-log: '(count {$new_packages})' package'"$package_message_tense" --command='pacman -Qc '"$new_packages"
end
