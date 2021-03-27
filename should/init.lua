local Expression
if game then
	Expression = require(script.Expression)
else
	Expression = require("./Expression")
end

local function e(value)
	return Expression.new(value)
end

return e
