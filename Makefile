.PHONY: install brew
.SILENT:
install:
	$(MAKE) brew;
brew:
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
