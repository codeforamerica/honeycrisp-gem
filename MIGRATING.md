# Migration Guide

## Migrating from <= 0.17.0 to 0.18.0
The project switched to the [PolyForm Noncommerical license](https://polyformproject.org/licenses/noncommercial/1.0.0). Please review `LICENSE.txt` to ensure your project falls within the license guidelines. There are no functionality or API changes in this version otherwise.

## Migrating from <= 0.16.x to 0.17.0
In `0.17.0`, we want to support Material Icons in Rails 8 Projects by utilizing `url` instead of `font-url` which is a sprockets-rails based method (utilizes [`asset_path` defined in sprockets-rails gem](https://github.com/rails/sprockets-rails/blob/266ec49f3c7c96018dd75f9dc4f9b62fe3f7eecf/lib/sprockets/rails/helper.rb#L286)).
We noticed that the icons did not get compiled correctly for Rails 8 projects since it does not use sprockets, so here we're utilizing the url() method that should be supported in both Rails 7 and 8.

## Migrating from <= 0.15.2 to 0.16.0
⚠️ In `0.16.0` we are improving accessibilty for several of our CfaFormBuilder elements (`cfa_checkbox_set`, `cfa_input_field`, `cfa_radio_set`, `cfa_radio_set_with_follow_up`, `cfa_range_field`, `cfa_date_select`, `cfa_textarea`, `cfa_select`) by utilizing the `aria-describedby` attribute to incorporate `help_text_id` (copied over from v2 form builder). The help text is also moved out of the label (see `label_contents` method which no longer takes in `help_text` argument) which allows the label and the help text to be read as separate pieces of information. Due to the change in the `label_contents` method, we recommend all those migrating to the new version to audit the codebase for the use fo this method and update accordingly.

## Migrating from <= 0.14.3 to 0.15.0
For `0.14.4`, we updated the focus outline behavior to have a darker outline color (new color `$color-gold`) and an offset against focusable elements.
The focus on accordion component was also updated (previously only the baseline blue outline was applied on focus on the `.accordion__button` element).
This accessibility improvement was necessary to meet WCAG 2.2 SC 1.4.11 Non-text Contrast (Level AA) criterion.

See [pull request](https://github.com/codeforamerica/honeycrisp-gem/pull/340/files) for full details.

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
