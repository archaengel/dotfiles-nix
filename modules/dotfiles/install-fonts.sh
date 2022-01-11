#!/usr/bin/bash

abnormal_exit () {
    echo $1
    exit 1
}

check_permissions () {
    if [[ $EUID -ne 0 ]]; then
        abnormal_exit "Please run as root"
    fi
}

repo=https://github.com/ryanoasis/nerd-fonts/
ligature_slug=raw/master/patched-fonts/JetBrainsMono/Ligatures/
Regular/complete/

regular_file=Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf
bold_file=Bold/complete/JetBrains%20Mono%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
italic_file=Italic/complete/JetBrains%20Mono%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
bold_italic_file=BoldItalic/complete/JetBrains%20Mono%20Bold%20Italic%20Nerd%20Font%20Complete%20Mono.ttf

install_fonts () {
    check_permissions
    mkdir /usr/share/fonts/truetype/jetbrains
    cd $_
    curl -L $repo$ligature_slug$regular_file -o JetBrainsMonoNF-Regular.ttf
    curl -L $repo$ligature_slug$bold_file -o JetBrainsMonoNF-Bold.ttf
    curl -L $repo$ligature_slug$italic_file -o JetBrainsMonoNF-Italic.ttf
    curl -L $repo$ligature_slug$bold_italic_file -o JetBrainsMonoNF-BoldItalic.ttf
}

install_fonts
