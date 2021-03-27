# should

Value matchers for Lua

## Example Usage

```lua
local e = require "should"

e(2 + 2)
  .should.equal(4)
  .shouldNot.beNil()
  .should.beTruthy()
```

More matchers can be found in the ``Matchers.lua`` file.

## To Do

* Comment
* Type check
* Test