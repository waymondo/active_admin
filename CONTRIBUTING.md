## Contributing

First off, thank you for considering contributing to Active Admin. It's people
like you that make Active Admin such a great tool.

### 1. Where do I go from here?

If you've noticed a bug or have a question that doesn't belong on the
[mailing list](http://groups.google.com/group/activeadmin) or
[Stack Overflow](http://stackoverflow.com/questions/tagged/activeadmin),
[search the issue tracker](https://github.com/activeadmin/activeadmin/issues?q=something)
to see if someone else in the community has already created a ticket.
If not, go ahead and [make one](https://github.com/activeadmin/activeadmin/issues/new)!

### 2. Fork & create a branch

If this is something you think you can fix, then
[fork Active Admin](https://help.github.com/articles/fork-a-repo)
and create a branch with a descriptive name.

A good branch name would be (where issue #325 is the ticket you're working on):

```sh
git checkout -b 325-add-japanese-translations
```

### 3. Get the test suite running

Make sure you're using a recent ruby and have the `bundler` gem installed, at
least version `1.14.3`. The most reliable `bundler` version to use is the same
Travis is using.

Install `appraisal` and the other common development dependencies:

```sh
bundle install
```

Install the development dependencies:

```sh
bundle exec appraisal install
```

Now you should be able to run the entire suite using:

```sh
bundle exec rake test
```

This will automatically run the tests against Rails 5.0. But you can easily run
tests against older versions of Rails too.

For example, you can run all tests against Rails 4.2:

```sh
bundle exec appraisal rails_42 rake test
```

or even just run specific tests. For example:

```sh
bundle exec appraisal rails_42 rspec spec/unit/belongs_to_spec.rb
```

The test run will generate a sample Rails application in `spec/rails` to run the
tests against.

If your tests are passing locally but they're failing on Travis, reset your test
environment:

```sh
rm -rf spec/rails && bundle exec appraisal update
```

If you want to stick with a specific older Rails version for a while, you can
also do `export BUNDLE_GEMFILE=gemfiles/rails_42.gemfile` and then run all
commands directly (`bundle exec rake test`, `bundle exec rake setup`) without
Appraisal.

#### 4. Did you find a bug?

* **Ensure the bug was not already reported** by searching on GitHub under [Issues](https://github.com/activeadmin/activeadmin/issues).

* If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/activeadmin/activeadmin/issues/new). 
Be sure to include a **title and clear description**, as much relevant information as possible, 
and a **code sample** or an **executable test case** demonstrating the expected behavior that is not occurring.

* If possible, use the relevant bug report templates to create the issue. 
Simply copy the content of the appropriate template into a .rb file, make the necessary changes to demonstrate the issue, 
and **paste the content into the issue description**:
  * [**Rails 5** issues](https://github.com/activeadmin/activeadmin/blob/master/lib/bug_report_templates/rails_5_master.rb)

### 5. Implement your fix or feature

At this point, you're ready to make your changes! Feel free to ask for help;
everyone is a beginner at first :smile_cat:

### 6. View your changes in a Rails application

Active Admin is meant to be used by humans, not cucumbers. So make sure to take
a look at your changes in a browser.

To boot up a test Rails app:

```sh
bundle exec rake local server
```

This will automatically create a Rails app if none already exists, and store it
in the `.test-rails-apps` folder.

You should now be able to open <http://localhost:3000/admin> in your browser.
You can log in using:

```
User: admin@example.com
Password: password
```

If you need to perform any other commands on the test application, just pass
them to the `local` rake task. For example, to boot the rails console:

```sh
bundle exec rake local console
```

Or to migrate the database:

```sh
bundle exec rake local db:migrate
```

### 7. Run tests against major supported Rails versions

Once you've implemented your code, got the tests passing, previewed it in a
browser, you're ready to test it against multiple versions of Rails.

```sh
bundle exec appraisal rake test
```

This runs our test suite against a couple of major versions of Rails.
Travis does essentially the same thing when you open a Pull Request.
We care about quality, so your PR won't be merged until all tests pass.

### 8. Make a Pull Request

At this point, you should switch back to your master branch and make sure it's
up to date with Active Admin's master branch:

```sh
git remote add upstream git@github.com:activeadmin/activeadmin.git
git checkout master
git pull upstream master
```

Then update your feature branch from your local copy of master, and push it!

```sh
git checkout 325-add-japanese-translations
git rebase master
git push --set-upstream origin 325-add-japanese-translations
```

Finally, go to GitHub and
[make a Pull Request](https://help.github.com/articles/creating-a-pull-request)
:D

### 9. Keeping your Pull Request updated

If a maintainer asks you to "rebase" your PR, they're saying that a lot of code
has changed, and that you need to update your branch so it's easier to merge.

To learn more about rebasing in Git, there are a lot of
[good](http://git-scm.com/book/en/Git-Branching-Rebasing)
[resources](https://help.github.com/articles/interactive-rebase),
but here's the suggested workflow:

```sh
git checkout 325-add-japanese-translations
git pull --rebase upstream master
git push --force-with-lease 325-add-japanese-translations
```

### 10. Merging a PR (maintainers only)

A PR can only be merged into master by a maintainer if:

* It is passing CI.
* It has been approved by at least two maintainers. If it was a maintainer who
  opened the PR, only one extra approval is needed.
* It has no requested changes.
* It is up to date with current master.

Any maintainer is allowed to merge a PR if all of these conditions are
met.
