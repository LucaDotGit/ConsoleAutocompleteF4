#include "Internal/Messaging.hpp"

#include "Internal/OnConsoleOpen.hpp"

namespace Internal::Messaging
{
	void Callback(F4SE::MessagingInterface::Message* a_msg)
	{
		switch (a_msg->type) {
			case F4SE::MessagingInterface::kGameDataReady: {
				auto* ui = RE::UI::GetSingleton();
				ui->RegisterSink(new OnConsoleOpen());
				break;
			}
		}
	}
}
