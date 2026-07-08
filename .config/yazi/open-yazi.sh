#!/bin/bash
# yazi-gui-desktop debe estar en ~/.local/share/applications/yazi-gui.desktop
# El parametro "$1" es la ruta que pasa el sistema (el %u)
kitty --hold yazi --cwd-file "$1"