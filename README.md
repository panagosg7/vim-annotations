vim-annotations
===============

Vim plugin intended for displaying type annotations of programs produced by
tools like [RefScript](https://github.com/UCSD-PL/RefScript).

![alt tag](https://raw.githubusercontent.com/panagosg7/vim-annotations/master/doc/neg.png)

This plugin has been inspired by the following plugins:
 - https://github.com/khorser/vim-qfnotes
 - https://github.com/bitc/vim-hdevtools



## Installation

The easiest way to install is through [Vundle](https://github.com/gmarik/Vundle.vim)

Just add the following line in your `.vimrc`:

    Bundle "panagosg7/vim-annotations"



## Valid input

This plugin is intended for displaying type annotations of TypeScript programs
produced by [nano-js] (https://github.com/UCSD-PL/nano-js).

In particular, the format recognized is the following:

    <col1>:<line1>-<line2>:<col2>::<content>

Where `<col1>` and `<line1>` are the column and line of the beginnig of the
annotated code and `<col2>` and `<line2>` those of the end. `<Content>` can be
any _singel-line_ string. End of line (`\n`) is supported, and will be shown
accordingly.



## Usage

### Load annotation file

    :LoadAnns /path/to/annotation/file

After the annotation file has been loaded the following operations are enabled.

### Load default annotation file

    :LoadAnnsDefault

The above loads the default annotations file `foo.vim.annot`, sparing the user
from having to specify a particular annotation file, if so desired.

### Invoke type query

 - Move cursor on expression that needs to be identified.
 - Hit `<F1>`. The relevant type should appear in the quickfix box.
 - By hitting `<F1>` multiple times, you can iterate over the possibly many
   expressions that contain the current screen cell. The expression that is 
   identified every time will be highlighted.


### Clear highlight

Hit `<F2>`, to clear selection.

### Hover Annotations

On `gvim` or `macvim` hovering the mouse over an identifier will display the
inferred type for the identifier, if one exists.


![hover type display](https://raw.githubusercontent.com/panagosg7/vim-annotations/master/doc/balloon.png)

