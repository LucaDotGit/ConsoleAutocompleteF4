#include "Internal/GetCommandsFunction.hpp"

namespace Internal
{
	inline static const auto BLACKLIST = std::unordered_set<std::string_view>{
		"UnlockWord"sv,
		"TeachWord"sv,
		"ADD NEW FUNCTIONS BEFORE THIS ONE!!!"sv
	};

	[[nodiscard]] inline static bool IsInvalid(const char* a_str) noexcept
	{
		return !a_str || *a_str == '\0' || std::isspace(*a_str);
	}

	[[nodiscard]] inline static const char* SanitizeString(const char* a_str) noexcept
	{
		return IsInvalid(a_str) ? "" : a_str;
	}

	static void Impl(std::span<RE::SCRIPT_FUNCTION> a_functions, RE::Scaleform::GFx::Movie* a_view, RE::Scaleform::GFx::Value& a_commands)
	{
		for (const auto& function : a_functions) {
			for (const auto useShortName : { false, true }) {
				const auto* name = useShortName ? function.shortName : function.functionName;
				if (IsInvalid(name) || BLACKLIST.contains(name)) {
					continue;
				}

				auto command = RE::Scaleform::GFx::Value();
				a_view->CreateObject(&command);

				auto params = RE::Scaleform::GFx::Value();
				a_view->CreateArray(&params);

				for (auto i = 0ui16; i < function.paramCount; i++) {
					auto param = RE::Scaleform::GFx::Value();
					a_view->CreateObject(&param);

					const auto* paramName = SanitizeString(function.parameters[i].paramName);
					param.SetMember("name"sv, paramName);

					params.PushBack(param);
				}

				const auto* description = SanitizeString(function.helpString);

				command.SetMember("name"sv, name);
				command.SetMember("description"sv, description);
				command.SetMember("requiresRef"sv, function.referenceFunction);
				command.SetMember("params"sv, params);

				a_commands.PushBack(command);
			}
		}
	}

	void GetCommandsFunction::Call(const Params& a_params)
	{
		if (a_params.argCount != 0) {
			return;
		}

		const auto consoleFunctions = RE::SCRIPT_FUNCTION::GetConsoleFunctions();
		const auto scriptFunctions = RE::SCRIPT_FUNCTION::GetScriptFunctions();

		auto commands = RE::Scaleform::GFx::Value();
		a_params.movie->CreateArray(&commands);

		Impl(consoleFunctions, a_params.movie, commands);
		Impl(scriptFunctions, a_params.movie, commands);

		a_params.retVal->operator=(commands);
	}
}
