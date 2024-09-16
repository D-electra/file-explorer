enum abstract AnsiAtt(Int) from Int to Int {
	var OFF = 0;

	var BOLD = 1;
	var UNDERLINE = 4;
	var BLINK = 5;
	var REVERSE_VIDEO = 7;
	var CONCEALED = 8;

	var BOLD_OFF = 22;
	var UNDERLINE_OFF = 24;
	var BLINK_OFF = 25;
	var NORMAL_VIDEO = 27;
	var CONCEALED_OFF = 28;

	var BLACK = 30;
	var RED = 31;
	var GREEN = 32;
	var YELLOW = 33;
	var BLUE = 34;
	var MAGENTA = 35;
	var CYAN = 36;
	var WHITE = 37;
	var DEFAULT_FOREGROUND = 39;

	var BLACK_BACK = 40;
	var RED_BACK = 41;
	var GREEN_BACK = 42;
	var YELLOW_BACK = 43;
	var BLUE_BACK = 44;
	var MAGENTA_BACK = 45;
	var CYAN_BACK = 46;
	var WHITE_BACK = 47;
	var DEFAULT_BACKGROUND = 49;
}

class Ansi {
	public static inline function wrap(v:Dynamic, atts:Array<AnsiAtt>):String {
		var result = Std.string(v);

		for (att in atts) {
			result = '\x1b[${att}m' + result;
			result += '\x1b[${getOff(cast att)}m';
		}

		return result;
	}

	public static function getOff(att:Int):AnsiAtt {
		// bold
		if (att == BOLD) return BOLD_OFF;
		// underline, blink, reverse video, concealed
		else if (att >= 4 && att <= 8) return att + 20;
		// foreground colors
		else if (att >= 30 && att <= 37) return DEFAULT_FOREGROUND;
		// background colors
		else if (att >= 40 && att <= 47) return DEFAULT_BACKGROUND;
		// others
		else return att;
	}
}
