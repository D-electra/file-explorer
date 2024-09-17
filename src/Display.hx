import sys.FileSystem;
import haxe.io.Path;

using StringTools;

enum abstract FileType(String) from String to String {
	var FOLDER;
	var PICTURE;
	var AUDIO;
	var VIDEO;
	var UNKNOWN;

	public static function resolve(path:String):FileType {
		if (FileSystem.isDirectory(path)) return FOLDER;
		return Config.associations.get(Path.extension(path).trim().toLowerCase()) ?? UNKNOWN;
	}
}

class Display {
	// private static final navPrefix = ' ←  →  ↑  ⟳  | ';
	// private static final navPrefix = ' ←  →  ↑  | ';
	private static final navPrefix = '';

	private static final spaces = ''.lpad(' ', navPrefix.length - 4);

	public static function printFolder(path:String) {
		path = Path.normalize(path);

		// TODO: clear console (cls don't work)
		for (i in 0...100) Sys.stdout().writeString('\n'); // kill me pls

		printHeader(path);

		var files = FileSystem.readDirectory(path);
		/*files.sort((a, b) -> {
			a = a.toLowerCase();
			b = b.toLowerCase();
			if (a > b) return -1;
			else if (a < b) return 1;
			else return 0;
		});*/
		files.sort((a, b) -> {
			a = a.toLowerCase();
			b = b.toLowerCase();

			var result = 0;
			if (a > b) result = 1;
			if (a < b) result = -1;

			var aFolder = FileSystem.isDirectory(Path.join([path, a]));
			var bFolder = FileSystem.isDirectory(Path.join([path, b]));

			if (aFolder && !bFolder) result = -1;
			else if (!aFolder && bFolder) result = 1;

			return result;
		});
		for (file in files) {
			var type = FileType.resolve(Path.join([path, file]));
			printFile(file, type);
		}
		Sys.stdout().writeString('\n');
		Sys.stdout().flush();
	}

	private static function printHeader(path:String) {
		Sys.stdout().writeString(Ansi.wrap('$navPrefix $path ', [BLACK, WHITE_BACK]) + '\n');
	}

	private static function printFile(name:String, type:FileType) {
		Sys.stdout().writeString('$spaces${Config.icons.get(type) ?? Config.icons.get(UNKNOWN)} $name\n');
	}
}
