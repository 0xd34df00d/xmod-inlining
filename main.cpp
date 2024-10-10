#include <iostream>
#include <vector>
#include <string>

bool isOpen(char ch)
{
	return ch == '(' || ch == '[';
}

bool matches(char l, char r)
{
	if (l == '(' && r == ')')
		return true;
	if (l == '[' && r == ']')
		return true;
	return false;
}

bool checkBrackets(std::string_view str)
{
	std::vector<char> stack;
	stack.reserve(str.size());

	for (auto ch : str)
	{
		if (isOpen(ch))
			stack.push_back(ch);
		else if (stack.empty())
			return false;
		else
		{
			auto inStack = stack.back();
			stack.pop_back();
			if (!matches(inStack, ch))
				return false;
		}
	}
	return stack.empty();
}

int main()
{
	constexpr size_t cnt = 100'000'000;
	auto input = std::string(cnt, '(') + std::string(cnt, ')');
	std::cout << checkBrackets(input) << '\n';
}
