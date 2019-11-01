# Migration Guide

## Migrating from <= 0.8.x to 0.9.0

For a full diff of changes, view the [pull request](https://github.com/codeforamerica/cfa-styleguide-gem/pull/123/files). A summary of significant changes is below.

### Breaking changes: SASS variables
In `0.9.0`, various SASS variables have been removed and will cause breakage if they're continued to be used in the host application.

Below are the variables that have been removed, along with their suggested replacements:

|original|suggested replacement|
|---|---|
|$padding-small|$s10|
|$padding-med|$s35|
|$padding-large|$s60|
|$padding-huge|$s155|
|$font-size-normal|$font-size-25|
|$font-size-small|$font-size-25-small|
|$font-size-smallest|$font-size-15|
|$font-size-normal|$font-size-25|
|$font-size-h1|$font-size-60|
|$font-size-h2|$font-size-35|
|$font-size-h3|$font-size-25|
|$font-size-h4|$font-size-25-small|
|$line-height-normal|$s25|
|$line-height-display|$s35|
|$color-darkest-grey|#121111|
|$color-dark-grey|#5F5854|
|$color-light-grey|#F7F5F4|
|$color-tan|#DFD7CC|
|$color-orange|#D48C00|
|$color-text-on-orange|#3D2800|

### Changes to overrides: SASS organization
`layout.scss` has been split into `slabs.scss` and `notices.scss`.

Spacing classes have been moved from `utilities.scss` to `spacing.scss`.

### Removals: CSS classes
A handful of CSS classes have been removed. If your project needs them or you're concerned 
about breaking, review the [diff](https://github.com/codeforamerica/cfa-styleguide-gem/pull/123/files).
