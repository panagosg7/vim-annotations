vim-annotations
===============

Vim plugin is intended for displaying type annotations of TypeScript programs
produced by [nano-js] (https://github.com/UCSD-PL/nano-js).

This plugin has been inspired by the following plugins:
https://github.com/khorser/vim-qfnotes
https://github.com/bitc/vim-hdevtools


## Installation

The easiest way to install is through [Vundle](https://github.com/gmarik/Vundle.vim)

Just add the following line in your `.vimrc`:

    Bundle "panagosg7/vim-annotations"


## Valid input

This plugin is intended for displaying type annotations of TypeScript programs
produced by [nano-js] (https://github.com/UCSD-PL/nano-js).

In particular, the format recognized is the following:

    <col1>:<line1>-<col2>:<line2>::<content>

Where `<col1>` and `<line1>` are the column and line of the beginnig of the
annotated code and `<col2>` and `<line2>` those of the end. `<Content>` can be
any _singel-line_ string. End of line (`\n`) is supported, and will be shown
accordingly.

This plugin has been inspired by the following plugins:
https://github.com/khorser/vim-qfnotes
https://github.com/bitc/vim-hdevtools


## Usage


### Load annotation file


### Invoke type query


### Clear highlight


