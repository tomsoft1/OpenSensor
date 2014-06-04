class Flow < Element

	def self.factory params
		Kernel.const_get(params[:type]).new(params)
	end
end
