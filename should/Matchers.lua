local Matchers = {}
local isRoblox = game ~= nil

-- Types

function Matchers:beA(type_)
	self.success = type(self.value) == type_
	self.fail = {
		normal = ("Value should be of type %s, got value %s of type %s")
			:format(tostring(type_), tostring(self.value), type(self.value));
		negate = ("Value should not be of type %s, got value %s")
			:format(tostring(type_), tostring(self.value));
	}
	self:evaluate()
end

if isRoblox then
	function Matchers:beATypeOf(type_)
		self.success = typeof(self.value) == type_
		self.fail = {
			normal = ("Value should be of type %s, got value %s of type %s")
				:format(type_, tostring(self.value), typeof(self.value));
			negate = ("Value should not be of type %s, got value %s")
				:format(type_, tostring(self.value));
		}
		self:evaluate()
	end

	function Matchers:beOfClass(className)
		self.success = self.value.className == className
		self.fail = {
			normal = ("Instance should be of class %s, got instance %s of type %s")
				:format(className, self.value.Name, self.value.className);
			negate = ("Instance should not be of class %s, got instance %s of type %s")
				:format(className, self.value.Name, self.value.className);
		}
		self:evaluate()
	end
end

-- Truthiness

function Matchers:beTrue()
	self.success = self.value == true
	self.fail = {
		normal = ("Value should be to true, got %s")
			:format(tostring(self.value));
		negate = ("Value should not be to true, got %s")
			:format(tostring(self.value));
	}
	self:evaluate()
end

function Matchers:beTruthy()
	self.success = self.value and true or false
	self.fail = {
		normal = ("Value should be truthy, got %s")
			:format(tostring(self.value));
		negate = ("Value should not be truthy, got %s")
			:format(tostring(self.value));
	}
	self:evaluate()
end

function Matchers:beNil()
	self.success = self.value == nil
	self.fail = {
		normal = ("Value should be nil, got %s")
			:format(tostring(self.value));
		negate = ("Value should not be nil, got %s")
			:format(tostring(self.value));
	}
	self:evaluate()
end

-- Functions

function Matchers:pass()
	assert(type(self.value) == "function", "Expression value must be a function")

	local success, err = pcall(self.value)
	self.success = success
	self.fail = {
		normal = ("Function should pass, got error %s")
			:format(err);
		negate = "Function should not pass"
	}
	self:evaluate()
end

function Matchers:error()
	assert(type(self.value) == "function", "Expression value must be a function")

	local success, err = pcall(self.value)
	self.success = not success
	self.fail = {
		normal = "Function should error";
		negate = ("Function should not error, got error %s"):format(err)
	}
	self:evaluate()
end

function Matchers:throw(message)
	assert(type(self.value) == "function", "Expression value must be a function")
	assert(type(message) == "string", "Expected error message must be a string")

	local _, err = pcall(self.value)
	self.success = err == message
	self.fail = {
		normal = ("Function should throw message %s, instead it threw %s")
			:format(message, err);
		negate = ("Function should not throw message %s")
			:format(message)
	}
	self:evaluate()
end


function Matchers:Return(...)
	assert(type(self.value) == "function", "Expression value must be a function")

	local expectedReturns = {...}
	local returns = {self.value()}

	if self.negate then
		 for i, v in ipairs(expectedReturns) do
			if returns[i] == v then
				self.success = true
				self.fail.negate = ("Function should not return %s at argument %d")
					:format(tostring(v), i)
				break
			end
		end
	else
		for i, v in ipairs(expectedReturns) do
			if returns[i] ~= v then
				self.success = false
				self.fail.normal = ("Function should return %s at argument %d, got %s")
					:format(tostring(v), i, tostring(returns[i]))
				break
			end
		end
	end

	self:evaluate()
end

-- Numbers

function Matchers:equal(x)
	self.success = self.value == x
	self.fail = {
		normal = ("Value should equal %s, got %s"):format(tostring(x), tostring(self.value));
		negate = ("Value should not equal %s, got %s"):format(tostring(x), tostring(self.value));
	}
	self:evaluate()
end

function Matchers:beGreaterThan(x)
	assert(type(self.value) == "number", "Expression value must be a number")
	assert(type(x) == "number", "Matching value must be a number")

	self.success = self.value > x
	self.fail = {
		normal = ("Number %d should be greater than %d")
			:format(self.value, x);
		negate = ("Number %d should not be greater than %d")
			:format(self.value, x);
	}
	self:evaluate()
end

function Matchers:beGreaterThanOrEqualTo(x)
	assert(type(self.value) == "number", "Expression value must be a number")
	assert(type(x) == "number", "Matching value must be a number")

	self.success = self.value >= x
	self.fail = {
		normal = ("Number %d should be greater than or equal to %d")
			:format(self.value, x);
		negate = ("Number %d should not be greater than or equal to %d")
			:format(self.value, x);
	}
	self:evaluate()
end

function Matchers:beLessThan(x)
	assert(type(self.value) == "number", "Expression value must be a number")
	assert(type(x) == "number", "Matching value must be a number")

	self.success = self.value < x
	self.fail = {
		normal = ("Number %d should be less than %d"):format(self.value, x);
		negate = ("Number %d should not be less than %d"):format(self.value, x);
	}
	self:evaluate()
end

function Matchers:beLessThanOrEqualTo(x)
	assert(type(self.value) == "number", "Expression value must be a number")
	assert(type(x) == "number", "Matching value must be a number")

	self.success = self.value >= x
	self.fail = {
		normal = ("Number %d should be less than or equal to %d")
			:format(self.value, x);
		negate = ("Number %d should not be less than or equal to %d")
			:format(self.value, x);
	}
	self:evaluate()
end

function Matchers:beEvenlyDivisibleBy(x)
	assert(type(self.value) == "number", "Expression value must be a number")
	assert(type(x) == "number", "Divisor value must be a number")

	local remainder = self.value % x
	self.success = remainder == 0
	self.fail = {
		normal = ("Number %d should be evenly divisible by %d, has a remainder of %d")
			:format(self.value, x, remainder);
		negate = ("Number %d should not be evenly divisible by %d")
			:format(self.value, x, remainder);
	}
	self:evaluate()
end

function Matchers:beAnInteger()
	assert(type(self.value) == "number", "Expression value must be a number")

	self.success = math.floor(self.value) == self.value
	self.fail = {
		normal = ("Number %d should be an integer"):format(self.value);
		negate = ("Number %d should not be an integer"):format(self.value);
	}
	self:evaluate()
end

function Matchers:haveDecimals()
	assert(type(self.value) == "number", "Expression value must be a number")

	self.success = math.floor(self.value) == self.value
	self.fail = {
		normal = ("Value %d should have decimals"):format(self.value);
		negate = ("Value %d should not have decimals"):format(self.value);
	}
	self:evaluate()
end

-- Strings

function Matchers:match(pattern)
	assert(type(self.value) == "string", "Expression value must be a string")
	assert(type(pattern) == "string", "Matching pattern must be a string")

	local match = self.value:match(pattern)
	self.success = match ~= nil
	self.fail = {
		normal = ("String \"%s\" should match pattern \"%s\", instead matched \"%s\""):
			format(self.value, pattern, tostring(match));
		negate = ("String \"%s\" should not match pattern \"%s\", instead matched \"%s\""):
			format(self.value, pattern, tostring(match))
	}
	self:evaluate()
end

-- Tables

function Matchers:containKey(key)
	assert(type(self.value) == "table", "Expression value must be a table")
	assert(key ~= nil, "Key must not be nil")

	local value = self[key]
	self.success = value ~= nil
	self.fail = {
		normal = ("Table should contain key %s")
			:format(tostring(key), tostring(value));
		negate = ("Table should not contain key %s, has a value of %s")
			:format(tostring(key), tostring(value));
	}
	self:evaluate()
end

function Matchers:containValue(value)
	assert(type(self.value) == "table", "Expression value must be a table")
	assert(value ~= nil, "Value must not be nil")

	local foundKey
	for i, v in pairs(self.value) do
		if v == value then
			self.success = true
			foundKey = i
			break
		end
	end

	self.fail = {
		normal = ("Table should contain value %s")
			:format(tostring(value));
		negate = ("Table should not contain value %s, found at key %s")
			:format(tostring(value), foundKey)
	}
	self:evaluate()
end

function Matchers:beAnArray()
	assert(type(self.value) == "table", "Expression value must be a table")

	self.success = true
	local nonNumberKey

	for i, _ in pairs(self.value) do
		if type(i) ~= "number" then
			self.success = false
			nonNumberKey = i
			break
		end
	end

	self.fail = {
		normal = ("Table should be an array, found a non-number key %s")
			:format(tostring(nonNumberKey));
		negate = "Table should not be an array";
	}

	self:evaluate()
end

function Matchers:beAnArrayOfLength(x)
	assert(type(self.value) == "table", "Expression value must be a table")

	local length = #self.value
	self.success = x == length
	self.fail = {
		normal = ("Array should be of length %d, instead its length is %d"):format(x, length);
		negate = ("Array should not be of length %d"):format(x);
	}
	self:evaluate()
end

return Matchers
