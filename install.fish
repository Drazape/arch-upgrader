#!/usr/bin/env fish
# Only allow execution as root
if ! fish_is_root_user
	echo (status basename)': Must be ran as root'
	return  1
end



set --global official_git_repository_name 'arch-upgrader'
set --global official_git_repository_url 'https://github.com/Dracape/'{$official_git_repository_name}



# Handle external configuration
## Arguments
### Switches
argparse 'r/repository=&' 'R/rootdir=&!path is --type=dir {$_flag_value}' 'v/verbose&' -- {$argv}
if test "$status" -ne 0 # Exit on incorrect arguments
    return 1
end

### Positional
if test (count {$argv}) -ne 0
	echo (status basename)': Positional arguments are not supported'
	return 1
else
	set --erase --local argv
end

### Individual
## Verbose
if set -ql _flag_verbose || set -qlx VERBOSE
	set --global --export VERBOSE '--verbose'
	set --erase --local _flag_verbose
end

set --erase --local _flag_{R,r,V,h}


# Set source-code directory path
## Overwrite REPOSITORY environment variable if the equivalent switch is provided
if set -ql _flag_repository
	set --function REPOSITORY {$_flag_repository}
	set --erase --local _flag_r{epository,} # Remove the flags as already set as REPOSITORY
end

## Parse repository switch/variable
if set -q REPOSITORY
	if path is -d {$REPOSITORY}/src # Set repository as local if the source code directory in the specified path exists
		if set -q VERBOSE
			echo 'Repository found locally: '{$REPOSITORY}
		end
		set --global source_code_dir {$REPOSITORY}/src
	else
		if ! string match --regex -- 'https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()!@:%_\\+.~#?&\\/\\/=]*)' {$REPOSITORY}
			echo -- (status basename)': Invalid path' 1>&2
			return 1
		end

		set --global repository_dir (mktemp --directory /tmp/"$(string split '/' "$REPOSITORY" | tail -n 1)"-'XXXXXXXXX')
		set --global tmp_repo

		git clone "$REPOSITORY" "$repository_dir"
		if test {$status} -ne 0
			return 1
		end

		set --erase --function REPOSITORY
		set --global source_code_dir {$repository_dir}/src
	end
end

## Fallback
if ! path is -d {$source_code_dir}
	if path is -d {$PWD}/src # Local
		set --global source_code_dir {$PWD}/src
	else # Official remote
		set --global repository_dir (mktemp --directory /tmp/"$official_git_repository_name"-XXXXXXXXXX)
		set --global tmp_repo
		git clone "$official_git_repository_url"'.git' {$repository_dir}
		set --global source_code_dir {$repository_dir}/src
	end
end



# Install to local-vendor directory
if set -q VERBOSE # Verbosity announcement
	echo (status basename)': Operating in '{$source_code_dir}
end
cd {$source_code_dir}


## Operate
### Determine installation paths
begin
	set --local files (fd . --type=file)

	set --function scripts (string match --regex --entire '\.fish$' {$files})
	set --function systemd_units (string match --regex --entire --invert '\.fish$' {$files})
end

set --function install_systemd_units (string replace --regex 'services/((?<=services/).+$)' '\1.service' {$systemd_units} | string replace --all '/main' \0 | string replace 'type/' \0 | string replace --regex '^systemd-units' 'update-packages' | string replace '/system-update' \0 | string replace --regex '((pacman|flatpak))' '\1-update' | string replace '/systemd-units' \0 | string replace --all '/' '_' | string replace 'pacman-update_rate-mirrors.' 'rate-mirrors.')
set --function install_scripts (path change-extension \0 {$scripts} | string replace '/main' \0 | string replace --all '/sub' \0 | string replace 'type/' \0 | string replace --regex '((pacman|flatpak))' '\1-update' | string replace '/notifier' '_notifiers')


### Remove old files
if ! set -ql _flag_vendor
	if rm -rf "$_flag_rootdir"/usr/lib/{pacman-update_notifiers,systemd/{system,user}/{pacman,flatpak}*}
		if set -q VERBOSE
			echo (status basename)': Removed old files'
		end
	end
end


### Install
#### Executables (fish scripts)
echo (status basename)': Installing executables'
for i in (seq 1 (count {$scripts}))
	install {$VERBOSE} -D {$scripts[$i]} "$_flag_rootdir"/usr/lib/{$install_scripts[$i]}
end

#### Systemd units
echo (status basename)': Installing systemd units'
for i in (seq 1 (count {$systemd_units}))
	if string match --entire --quiet '_user' {$install_systemd_units[$i]}
		set --function unit_type 'user'
		set install_systemd_units[$i] (string replace '_user' \0 {$install_systemd_units[$i]})
	else
		set --function unit_type 'system'
	end

	install {$VERBOSE} -D --mode=644 {$systemd_units[$i]} "$_flag_rootdir"/usr/lib/systemd/{$unit_type}/{$install_systemd_units[$i]} 
end
