local Matchers
if game then
	Matchers = require(script.Parent.Matchers)
else
	Matchers = require("./Matchers")
end
local Expression = {}

local should_keyword = "should"
local negate_keyword = "shouldNot"

function Expression.new(value)
	local self = {
		value = value;
		success = false;
		negate = false;
		fail = {
			normal = "";
			negate = "";
		};
	}
	setmetatable(self, Expression)
	return self
end

function Expression:evaluate()
	if self.negate then
		if self.success then
			error("Expression failed:\n"..self.fail.negate)
		end
	else
		if not self.success then 
			error("Expression failed:\n"..self.fail.negate)
		end
	end

	self:_reset()
end

function Expression:_reset()
	local new = Expression.new(self.value)
	for i, v in pairs(new) do 
		self[i] = v
	end
end

Expression.__index = function(self, k)
	if k == negate_keyword then
		self.negate = not self.negate
		return self
	elseif k == should_keyword then
		return self
	end

	if Matchers[k] then
		return function(...)
			Matchers[k](self, ...)
			return self
		end
	end

	return Expression[k]
end

return Expression