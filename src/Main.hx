import sys.FileSystem;
import haxe.io.Path;

using StringTools;

// final navPrefix = ' ←  →  ↑  ⟳  | ';
// final navPrefix = ' ←  →  ↑  | ';
final navPrefix = '';

var folderPath:String;
var folderFiles:Array<FileInfo>;

function main() {
	folderPath = Sys.args()[0] ?? '';
	folderPath = Path.normalize(folderPath.trim());
	if (folderPath == '') folderPath = Path.normalize(Sys.getCwd());
	if (!FileSystem.isDirectory(folderPath)) throw new haxe.exceptions.ArgumentException('path');

	folderFiles = getFolderFiles(folderPath);
	Display.refresh();

	while (true) waitForInput();
}

function getFolderFiles(path:String):Array<FileInfo> {
	var result = [for (file in FileSystem.readDirectory(folderPath)) new FileInfo(Path.join([folderPath, file]))];
	result.sort((a, b) -> {
		if (a.name > b.name) return -1;
		else if (a.name < b.name) return 1;
		else return 0;
	});
	result.sort((a, b) -> {
		if (a.isFolder && !b.isFolder) return -1;
		else if (!a.isFolder && b.isFolder) return 1;
		else return 0;
	});
	return result;
}

function waitForInput() {
	var input = Sys.stdin().readLine();
	var newPath = Path.join([folderPath, input]);
	if (FileSystem.isDirectory(newPath)) {
		folderPath = newPath;
		folderFiles = getFolderFiles(folderPath);
	} else
		Sys.command(newPath);

	Display.refresh();
}

class Display {
	public static function refresh() {
		Sys.println('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n'); // kill me
		Sys.println(Ansi.wrap(getHeaderDisplay(folderPath), [BLACK, WHITE_BACK]));
		Sys.println('');
		for (file in folderFiles) Sys.println(getFileDisplay(file));
		Sys.println('');
	}

	public static function getHeaderDisplay(path:String):String {
		var formattedPath = Path.normalize(path).split('/').join(' > ');
		return '$navPrefix $formattedPath ';
	}

	private static final spaces = ''.lpad(' ', navPrefix.length - 4);
	public static function getFileDisplay(file:FileInfo):String {
		return file.isFolder ? '$spaces🗀  ${file.name}' : '$spaces🗎  ${file.name}';
	}
}
