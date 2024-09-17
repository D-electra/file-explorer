import haxe.io.Eof;
import haxe.io.BytesBuffer;
import sys.io.Process;
import sys.FileSystem;
import haxe.io.Path;

using StringTools;

var args:Array<String> = [];
var path:String;

function main() {
	args = Sys.args();

	path = args.shift()?.trim() ?? '';
	if (path == '') path = Sys.getCwd();

	if (!FileSystem.isDirectory(path)) throw new haxe.exceptions.ArgumentException('path');

	Config.load();

	Display.printFolder(path);

	while (true) waitForInput();
}

function waitForInput() {
	Sys.print('Open: ');
	try {
		var input = readInput();
		var newPath = Path.join([path, input]);
		if (FileSystem.isDirectory(newPath)) path = newPath;
		else Sys.command(newPath); // TODO: remove process outputs

		Display.printFolder(path);
	} catch(e) Sys.println('\nError: $e');
}

function readInput() {
	var buf = new BytesBuffer();
	var last = 0, s = '';
	try {
		while ((last = Sys.stdin().readByte()) != 10) buf.addByte(last);
		s = buf.getBytes().getString(0, buf.length, RawNative);
		if (s.charCodeAt(s.length - 1) == 13) s = s.substr(0, -1);
	} catch(e) {
		s = buf.getBytes().getString(0, buf.length, RawNative);
		if (s.length == 0) Sys.println('\nError: $e');
	}
	return s;
}
