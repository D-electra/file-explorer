import sys.io.File;
import sys.FileSystem;
import haxe.xml.Access;
import Display.FileType;

using StringTools;

class Config {
	public static var associations:Map<String, FileType> ;
	public static var icons:Map<FileType, String>;

	public static function reset() {
		associations = [
			'png' => PICTURE,
			'jpg' => PICTURE,
			'jpeg' => PICTURE,

			'mp3' => AUDIO,
			'ogg' => AUDIO,
			'wav' => AUDIO,

			'mp4' => VIDEO
		];

		icons = [
			FOLDER => '📁',
			PICTURE => '🌆',
			AUDIO => '🎧',
			VIDEO => '🎞️',
			UNKNOWN => '📄'
		];
	}

	public static function load() {
		reset();

		if (!FileSystem.exists('config.xml')) return;

		var xml = Xml.parse(File.getContent('config.xml'));
		var access = new Access(xml.firstElement());

		for (assoc in access.nodes.assoc) {
			if (!assoc.has.ext || !assoc.has.type) continue;

			if (assoc.att.ext.contains('/')) for (ext in assoc.att.ext.split('/'))
				associations[ext.trim().toLowerCase()] = assoc.att.type.trim().toUpperCase();
			else
				associations[assoc.att.ext.trim().toLowerCase()] = assoc.att.type.trim().toUpperCase();
		}

		for (icon in access.nodes.icon) {
			if (!icon.has.type || !icon.has.emoji) continue;
			icons[icon.att.type.trim().toUpperCase()] = icon.att.emoji;
		}
	}
}
