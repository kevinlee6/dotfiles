.SILENT:
install:
	# If there is Homebrew (must be default)
	if [ -d "$$(brew --prefix)" ] && [ -f ~/Brewfile ];\
	then\
		echo 'Homebrew detected.';\
		cd ~;\
		brew bundle;\
		echo 'Installing fzf';\
		printf 'y\y\nn' | "$$(brew --prefix)"/opt/fzf/install;\
	else\
		echo 'false';\
	fi;
