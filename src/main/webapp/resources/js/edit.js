var showSfProps = function(prop) {
	$('#task_id').val(prop.id);
	$('#task_name').val(prop.taskName);
	$('#workload').val(prop.workload);
	$('#worker').val(prop.worker);
	$('#location').val(prop.location);
	$('#comment').val(prop.comment);
};

var showPresentation = function(data) {

	var attrs = data.attributes.attrs;

	if (isLink(data)) {

		$("#presentation-node").attr("style", "display : none;");
		$("#presentation-link").attr("style", "display : inline;");

		var conn = attrs[".connection"];

		var dash = conn["stroke-dasharray"];
		if (!dash) {
			dash = 0;
		}
		$("#dash").val(dash);

		var smooth = data.attributes["smooth"];
		if (!smooth) {
			$("#smooth").bootstrapToggle('off');
		} else {
			$("#smooth").bootstrapToggle('on');
		}

	} else {

		$("#presentation-node").attr("style", "display : inline;");
		$("#presentation-link").attr("style", "display : none;");

		// Fill Color
		var type;
		if (attrs.circle) {
			type = attrs.circle;
		} else if (attrs.rect) {
			type = attrs.rect;
		}

		var fill_color_type = type.fill;
		$('#typeSelector div').css('backgroundColor', fill_color_type);

		// -------------------------------------------------

		var text = attrs.text;

		// Text Color
		var fill_color_text = text.fill;
		$('#colorSelector div').css('backgroundColor', fill_color_text);

		// Font Size
		var fontSize = text["font-size"];

		$('#jquery-ui-slider').slider({
			value : fontSize
		});
		$('#jquery-ui-slider-value').text(fontSize);

	}

};

var updateSfProps = function(cell) {
	if (cell !== null) {
		cell.sfProp = {
			id : cell.id,
			taskName : $('#task_name').val(),
			workload : $('#workload').val(),
			worker : $('#worker').val(),
			location : $('#location').val(),
			comment : $('#comment').val(),
		};
		$("#doc-list").empty();
	}
};

var updatePresentation = function(cell) {

	if (cell !== null) {
		var attributes = cell.attributes;
		var attrs = attributes.attrs;

		if (isLink(cell)) {
			var conn = attrs[".connection"];

			conn["stroke-dasharray"] = $("#dash").val();
			attributes["smooth"] = $("#smooth").prop('checked');

		} else {

			// テキスト情報
			var text = attrs.text;

			var text_color = $('#colorSelector div').css('backgroundColor');
			text.fill = text_color;

			var fontSize = $("#jquery-ui-slider-value").text();
			text["font-size"] = fontSize;

			// ---------------------------

			// Fill情報

			var type;
			if (attrs.circle) {
				type = attrs.circle;
			} else if (attrs.rect) {
				type = attrs.rect;
			}

			var type_color = $('#typeSelector div').css('backgroundColor');
			type.fill = type_color;
		}

	}
};

$(function() {

	// テキストサイズのためのSlider
	$(function() {
		$('#jquery-ui-slider').slider({
			range : 'min',
			min : 0,
			max : 50,
			step : 1,
			slide : function(event, ui) {
				$('#jquery-ui-slider-value').text(ui.value)
			},
			stop : function(event, ui) {
				$('#jquery-ui-slider-value').trigger("change");// ダミー
			}
		});
	});

	// TEXT情報のためのColor pickup
	$(function() {
		$('#colorSelector').ColorPicker({
			onShow : function(colorpicker) {
				$(colorpicker).fadeIn(500);
				return false;
			},
			onHide : function(colorpicker) {
				$(colorpicker).fadeOut(500);
				return false;
			},
			onSubmit : function(hsb, hex, rgb) {
				$('#colorSelector div').css('backgroundColor', '#' + hex);
				$('#jquery-ui-slider-value').trigger("change");// ダミー
			},
			onBeforeShow : function() {
				var color = $('#colorSelector div').css('backgroundColor');
				$(this).ColorPickerSetColor(color);
			}
		});
	});

	// FillのためのColor pickup
	$(function() {
		$('#typeSelector').ColorPicker({
			onShow : function(colorpicker) {
				$(colorpicker).fadeIn(500);
				return false;
			},
			onHide : function(colorpicker) {
				$(colorpicker).fadeOut(500);
				return false;
			},
			onSubmit : function(hsb, hex, rgb) {
				$('#typeSelector div').css('backgroundColor', '#' + hex);
				$('#jquery-ui-slider-value').trigger("change");// ダミー
			},
			onBeforeShow : function() {
				var color = $('#typeSelector div').css('backgroundColor');
				$(this).ColorPickerSetColor(color);
			}
		});
	});

});
