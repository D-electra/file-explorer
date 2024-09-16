import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import sys.FileStat;
import sys.io.FileInput;

class FileInfo {
	public var name:String;
	public var stat:FileStat;

	public var isFolder:Bool;
	public var file:FileInput;

	public function new(path:String) {
		name = Path.withoutDirectory(path);
		stat = FileSystem.stat(path);

		isFolder = FileSystem.isDirectory(path);
		if (!isFolder) file = File.read(path);
	}
}
