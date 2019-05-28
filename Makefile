.SILENT:
install:
	# If there is Homebrew (must be default)
	if [ -d "$$(brew --prefix)" ] && [ -f ~/Brewfile ];\
	then\
		echo '\nHomebrew detected.';\
		cd ~;\
		brew bundle;\
		echo '\nInstalling fzf';\
		printf 'y\y\nn' | "$$(brew --prefix)"/opt/fzf/install;\
		echo '\nFinished installing Homebrew.';\
	else\
		echo '\nHomebrew not detected';\
	fi;\
	echo '\nYou will have to manually use stow to symlink. It is not done automatically as a precaution; pick what you want to stow.';
