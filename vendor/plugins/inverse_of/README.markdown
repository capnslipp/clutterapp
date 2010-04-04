# Inverse Of

Backport of ActiveRecord 2.3.6's inverse associations feature.

    class Parent < ActiveRecord::Base
      has_one :child, :inverse_of => :parent
    end

    class Child < ActiveRecord::Base
      belongs_to :parent, :inverse_of => :child
    end

Now:

    parent = Parent.first
    parent.child.parent.equal?(parent)  # true

Without inverse associations, the last line is false.  Although
ActiveRecord does perform database query caching, you still suffer the
overhead of creating unnecessary ActiveRecord objects.

Inverse associations are also necessary to support validations on the
parent which must fire before the parent is saved.  For example:

    class Parent < ActiveRecord::Base
      has_one :child
      accepts_nested_attributes_for :child
    end

    class Child < ActiveRecord::Base
      belongs_to :parent
      validates_presence_of :parent_id
    end

    Parent.new(:child_attributes => {:name => 'child name'}).valid?

Here, the parent object fails validation, because the parent_id is not
set yet.  If inverses are declared, and the validation runs on the
association rather than the ID, the validation passes.

    class Parent < ActiveRecord::Base
      has_one :child, :inverse_of => :parent
      accepts_nested_attributes_for :child
    end

    class Child < ActiveRecord::Base
      belongs_to :parent
      validates_presence_of :parent
    end

Note that running the Child validations will now require loading the
Parent if it's not already loaded.  On the upside, it will now also
validate that the parent_id actually points to an existing record.
However, you may wish to define a custom validation to check only the
ID if the association is not set to avoid the extra database hit.

Inverse Of supports `has_one`, `has_many`, and `belongs_to`
associations, including polymorphic `belongs_to`.  Behavior should
exactly match Rails 2.3.6; please file any differences
[as a bug](http://github.com/oggy/inverse_of/issues).

## Contributing

* Bug reports: http://github.com/oggy/inverse_of/issues
* Source: http://github.com/oggy/inverse_of
* Patches: Fork on Github, send pull request.
  * Ensure patch includes tests.
  * Leave the version alone, or bump it in a separate commit.

## Copyright

Copyright (c) 2009-2010 George Ogata, released under the MIT license
