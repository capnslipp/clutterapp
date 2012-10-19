# ClutterApp

ClutterApp is an open-ended, dirt-stupid, limitlessly-hierarchical personal-information-manager, distributed in the form of a Rails app.



## Requirements

A webserver running:

* Ruby 1.8.7
* Rails 2.3.11
* and a connection to the RubyGems mainframe to fetch the [authlogic](http://rubygems.org/gems/authlogic) and [jrails](http://rubygems.org/gems/jrails) gems



## Installation

1. Replace all instances of &lsquo;`_fill_in_`&rsquo; in the project with reasonable values (some of which can be garnered from a fresh Rails project).
2. Install the dependencies with `rake gems:install`
3. Set up the database(s) (as necessary in `config/database.yml`) and run `rake db:setup`.

That's really all it should take. If trouble abounds, [strike back](http://github.com/clutterapp/clutterapp/issues).


## Contributing

You're encouraged to contribute to ClutterApp in any way you please. As it stands, the project is not being actively developed, so any changes/additions you make will be held in high regard.

Issues may be filed for bugs, feature requests, etc. at [github.com/clutterapp/clutterapp/issues](http://github.com/clutterapp/clutterapp/issues).


### Contributors

Although ClutterApp is [Slipp D's baby](http://instagr.am/p/Q5yjaHDUGb/), it has seen the fine handiwork of a handful of other chaps.

The full list of contributors in this codebase (via `git log --all --format='%aN (%aE)' | sort -u`) is:

* **Slipp D. Thompson** ([<img src="readme/graphics/font-awesome.icon-github.bk-tr.s84+8.png" height="16" align="absmiddle" style="height: 1.2em;" alt="GitHub"/>](http://github.com/slippyd/) | [<img src="readme/graphics/font-awesome.icon-home.bk-tr.s84+8.png" height="16" align="absmiddle" style="height: 1.2em;" alt="slippyd.com"/>](http://slippyd.com))
* **Josh Vera** ([<img src="readme/graphics/font-awesome.icon-github.bk-tr.s84+8.png" height="16" align="absmiddle" style="height: 1.2em;" alt="GitHub"/>](http://github.com/joshvera/) | [<img src="readme/graphics/font-awesome.icon-home.bk-tr.s84+8.png" height="16" align="absmiddle" style="height: 1.2em;" alt="joshvera.com"/>](http://www.joshvera.com))


---


## License

_(The MIT License)_

Copyright &copy; 2006-2012 ClutterApp, LLC

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Icons in readme documentation courtesy of Font Awesome - [http://fortawesome.github.com/Font-Awesome](http://fortawesome.github.com/Font-Awesome)
