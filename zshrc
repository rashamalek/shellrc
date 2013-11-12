# ~/.zshrc

# load all files from .shell/zshrc.d directory
if [ -d ~/.shellrc/zshrc.d ]; then
  for file in ~/.shellrc/zshrc.d/*; do
    source $file
  done
fi

# load all files from .shell/rc.d directory
if [ -d ~/.shellrc/rc.d ]; then
  for file in ~/.shellrc/rc.d/*; do
    source $file
  done
fi
