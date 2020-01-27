"""

 RageLib
 Copyright (C) 2008  Arushan/Aru <oneforaru at gmail.com>

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""

extends FileSystem
class_name RealFileSystem

var _context: RealContext

#TODO: this has to be refactored to be part of Real.FileEntry
var _customData: Dictionary # of {string: byte[]}
var _realDirectory: String

func Open(filename: String) -> void:
	_realDirectory = filename
	_context = RealContext.new(filename)
	
	BuildFS()

func BuildFSDirectory(dirEntry#FixCyclicRef: DirectoryEntry
					, fsDirectory: FSDirectory) -> void:
	fsDirectory.Name = dirEntry.Name
	
	var dir = Directory.new()
	dir.open(dirEntry._directory)
	dir.list_dir_begin(true, false)
	var file_name = dir.get_next()
	
	var path
	while file_name != "":
		path = dir.get_current_dir() + "/" + file_name
		
		if dir.current_is_dir():
			var sub_dir = FSDirectory.new()
			BuildFSDirectory(dirEntry.GetDirectory(path), sub_dir)
			dir.ParentDirectory = fsDirectory
			fsDirectory.AddObject(dir)
		else:
			print("Found file: " + file_name)
		
		file_name = dir.get_next()
		
	dir.list_dir_end()
	
	
#	for i in range(dirEntry.DirectoryCount):
#	for (var i = 0; i < dirEntry.DirectoryCount; i++ )
#		var dir = new Directory();
#		BuildFSDirectory(dirEntry.GetDirectory(i), dir);
#		dir.ParentDirectory = fsDirectory;
#		fsDirectory.AddObject(dir);
#	
#	for (var i = 0; i < dirEntry.FileCount; i++ )
#	{
#		var fileEntry = dirEntry.GetFile(i);
#
#		File file;
#		file = new File( 
#						()=> (_customData.ContainsKey(fileEntry.FullName) ? _customData[fileEntry.FullName] : fileEntry.GetData()),     
#						data => _customData[fileEntry.FullName] = data,
#						() => _customData.ContainsKey(fileEntry.FullName)
#					);
#
#		file.CompressedSize = fileEntry.Size;
#		file.IsCompressed = false;
#		file.Name = fileEntry.Name;
#		file.Size = fileEntry.Size;
#		file.IsResource = fileEntry.IsResourceFile;
#		file.ResourceType = fileEntry.ResourceType;
#		file.ParentDirectory = fsDirectory;
#
#		fsDirectory.AddObject(file)

func BuildFS() -> void:
	print("BuildFS")
	RootDirectory = FSDirectory.new()
	BuildFSDirectory(_context.RootDirectory, RootDirectory)
