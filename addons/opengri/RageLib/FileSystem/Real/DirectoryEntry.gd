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

extends RealEntry
class_name DirectoryEntry

var _directory: Directory
var _subdirs: Array # of Directory
var _files: Array # of File

func _init(context: RealContext, directory: Directory):
	Context = context
	_directory = directory;
	Name = _directory.get_current_dir() #FIXME: there should be Name, not FullPath
	
	#FIXME: ? fill _subdirs and _files
#	_subdirs = directory.GetDirectories();
#	_files = directory.GetFiles();

func IsDirectory() -> bool:
	return true

func GetDirectory(path: String) -> DirectoryEntry:
	var dir = Directory.new()
	dir.open(path)
	return DirectoryEntry.new(Context, dir)

func GetFile(path: String) -> FileEntry:
	var dir = File.new()
	dir.open(path)
	return DirectoryEntry.new(Context, dir)


#public int DirectoryCount
#public DirectoryEntry GetDirectory(int index)
#public int FileCount
#public FileEntry GetFile(int index)

#These 4 functions were used in only one place. Now they can be deleted

#func DirectoryCount() -> int:
#	print("#FIXME: ! fill _subdirs")
#	return _subdirs.size()
