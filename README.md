# Bicep Build Actions #

This is a GitHub Actions that runs the [bicep CLI](https://github.com/Azure/bicep) to build ARM templates.


## Inputs ##

* `files` (**Required**): one or more `.bicep` files to build, delimited by a space. eg. file1 file2 file3 ... It allows wildcards for recursive build.
* `version`: Version of the bicep CLI. It can be the exact version (eg. `v0.3.255`), wildcard (eg. `v0.3.x`) or `latest`. If omitted, `latest` is set as default.
* `exitOnFailure`: Exits with bicep CLI exit code if the build fails on a file. If omitted, `false` is set as default.


## Example Usage ##

### Run Bicep Build Action for Individual Files ###

```yaml
steps:
# Runs the bicep CLI action - individual files
- name: Run Bicep build
  uses: aliencube/bicep-build-actions@v0.3
  with:
    files: sample1.bicep sample2.bicep biceps/sample3.bicep biceps/sample4.bicep

# Checks the result
- name: Check the result
  shell: bash
  run: |
    shopt -s globstar
    ls -altR **/sample*.*
```


### Run Bicep Build Action for Recursive Files with Wildcard ###

```yaml
steps:
# Runs the bicep CLI action - recursive + wildcard
- name: Run Bicep build
  uses: aliencube/bicep-build-actions@v0.3
  with:
    files: '**/*.bicep'

# Checks the result
- name: Check the result
  shell: bash
  run: |
    shopt -s globstar
    ls -altR **/sample*.*
```


## Contribution ##

Your contributions are always welcome! All your work should be done in your forked repository. Once you finish your work with corresponding tests, please send us a pull request onto our `main` branch for review.


## License ##

**Bicep Build Actions** is released under [MIT License](http://opensource.org/licenses/MIT)

> The MIT License (MIT)
>
> Copyright (c) 2020 [aliencube.org](https://aliencube.org)
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
