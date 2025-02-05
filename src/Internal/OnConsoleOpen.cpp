#include "Internal/OnConsoleOpen.hpp"

namespace Internal
{
	static bool LoadMenu(std::string_view a_menuName, std::string_view a_filePath, std::string_view a_destinationVar)
	{
		const auto menu = RE::UI::GetSingleton()->GetMenu(a_menuName);
		if (!menu) {
			return false;
		}

		auto root = menu->uiMovie->asMovieRoot;
		auto target = RE::Scaleform::GFx::Value();

		if (!root->GetVariable(&target, a_destinationVar.data())) {
			return false;
		}

		auto filePath = RE::Scaleform::GFx::Value();
		root->CreateString(&filePath, a_filePath.data());

		auto loader = RE::Scaleform::GFx::Value();
		root->CreateObject(&loader, "flash.display.Loader");

		auto contentLoaderInfo = RE::Scaleform::GFx::Value();
		loader.GetMember("contentLoaderInfo"sv, &contentLoaderInfo);

		target.Invoke("addChild", nullptr, &loader, 1);

		RE::Scaleform::GFx::Value args[2];
		root->CreateObject(&args[0], "flash.net.URLRequest", &filePath, 1);
		args[1] = nullptr;

		return loader.Invoke("load", nullptr, args, 2);
	}

	RE::BSEventNotifyControl OnConsoleOpen::ProcessEvent(const RE::MenuOpenCloseEvent& a_event, RE::BSTEventSource<RE::MenuOpenCloseEvent>* a_source)
	{
		if (!a_event.opening || a_event.menuName != Globals::MENU_NAME) {
			return RE::BSEventNotifyControl::kContinue;
		}

		a_source->UnregisterSink(this);
		LoadMenu(Globals::MENU_NAME, Globals::FILE_PATH, Globals::DESTINATION_VAR);

		return RE::BSEventNotifyControl::kStop;
	}
}
