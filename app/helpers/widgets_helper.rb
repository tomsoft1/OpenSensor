module WidgetsHelper

	def widget_partial_name widget
		name=widget.type
		if !Widget.types.include?(name) then name="default" end
		"widgets/widget_#{name.downcase}"
	end

	def last_measure widget
		if widget.feed && measure=widget.feed.last_measure
			measure.value.to_s
		else
			"N/A"
		end
	end
end
