module WidgetsHelper

	def widget_partial_name widget
		name=widget.type.downcase
		if !["chart","gauge"].include?(name) then name="default" end
		"widgets/widget_#{name}"
	end

	def last_measure widget
		if widget.feed && measure=widget.feed.last_measure
			measure.value.to_s+" "+widget.feed.unit
		else
			"N/A"
		end
	end
end
