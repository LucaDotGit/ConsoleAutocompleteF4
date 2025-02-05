#pragma once

namespace Internal
{
	class GetCommandsFunction
		: public RE::Scaleform::GFx::FunctionHandler
	{
	public:
		void Call(const Params& a_params) override;
	};
}
