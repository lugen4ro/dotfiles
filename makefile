# The --restow parameter tells stow to unstow the packages first before stowing them again, 
# which is useful for pruning obsolete symlinks from the target directory
all:
	stow --verbose --target=$$HOME --restow */

delete:
	stow --verbose --target=$$HOME --delete */

