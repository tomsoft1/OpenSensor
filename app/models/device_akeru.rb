class DeviceAkeru < Device

	before_create :setType
	after_create :setType

	def setType
		self.type="Akeru"
	end
end
