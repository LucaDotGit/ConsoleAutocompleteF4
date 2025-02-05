#include "Internal/Scaleform.hpp"

#include "Internal/GetCommandsFunction.hpp"

namespace Internal::Scaleform
{
	bool Callback(RE::Scaleform::GFx::Movie* a_view, RE::Scaleform::GFx::Value* a_value)
	{
		logger::trace("Registering scaleform functions");

		auto getCommands = RE::Scaleform::GFx::Value();
		a_view->CreateFunction(&getCommands, new GetCommandsFunction());
		return a_value->SetMember("getCommands"sv, getCommands);
	}
}
