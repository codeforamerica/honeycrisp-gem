# Migration Guide

## Breaking changes: Migrating from <= 0.13.x to 0.14.0
⚠️ For `0.14.0`, we are reverting the change implemented in 0.13.0 since this broke the functionality of "none of the above" checkboxes for rails projects that utilize Rails form builder. For the use cases in which multiple checkboxes are on a single page, the toggle will be broken.

We will work on a fix that works universally in the future.

See [pull request](https://github.com/codeforamerica/honeycrisp-gem/pull/331/files) for full details.

## Breaking changes: Migrating from <= 0.12.x to 0.13.0
In `0.13.0` we fixed the use case when there are multiple checkbox sets on the page, the "none of the above" toggle was applying the toggle to every checkbox set on the page.

⚠️ Breaking change for folks using `id="none__checkbox"` without the "input name" appended. ex: `id="none__checkbox-programSelection"`

See [pull request](https://github.com/codeforamerica/honeycrisp-gem/pull/320/files) for full details.

## Migrating from <= 0.11.x to 0.12.0
In `0.12.0` we improved the accessibility of the Reveal component. Now the link that opened the reveal is a button with `aria-expanded` attributes which enables VoiceOver to announce the collapsed/expanded state of the reveal when clicked/toggled via keyboard in Safari.
Make sure to update any references to `.reveal__link` to `.reveal__button` in your repository if present.

*Note*: this does not currently work in Chrome/Firefox.

See [pull request](https://github.com/codeforamerica/honeycrisp-gem/pull/317/files) for full details.

## Migrating from <= 0.10.x to 0.11.0
Honeycrisp version `0.11.0` requires Ruby 3.0 or higher, so make sure you're
using a modern Ruby.

## Migrating from <= 0.9.x to 0.10.0

In `0.10.0`, SCSS files have now been namespaced into `stylesheets/honeycrisp`, from `stylesheets`.

If you imported the manifest (ie as `import 'cfa_styleguide_main'` in `application.scss`), no changes are needed.

If you imported SCSS files directly from Honeycrisp (e.g. `@import 'atoms/base';` in `application.scss`) then you will need to update your imports to have a `honeycrisp/` prefix (e.g. `@import 'atoms/base'` becomes `@import 'honeycrisp/atoms/base';`).

## Migrating from <= 0.8.x to 0.9.0

For a full diff of changes, view the [pull request](https://github.com/codeforamerica/honeycrisp-gem/pull/123/files). A summary of significant changes is below.

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
about breaking, review the [diff](https://github.com/codeforamerica/honeycrisp-gem/pull/123/files).
