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

var _directory: String

func _init(context#FixCyclicRef: RealContext
		, directory: String):
	Context = context
	_directory = directory;
	Name = _directory.get_file()

func IsDirectory() -> bool:
	return true

func GetDirectory(path: String):#FixCyclicRef -> DirectoryEntry:
#FixCyclicRef	return DirectoryEntry.new(Context, path)
	return get_script().new(Context, path)

func GetFile(path: String):#FixCyclicRef -> FileEntry:
	return FileEntry.new(Context, path)


#public int DirectoryCount
#public DirectoryEntry GetDirectory(int index)
#public int FileCount
#public FileEntry GetFile(int index)

#These 4 functions were used in only one place. Now they can be deleted

#func DirectoryCount() -> int:
#	print("#FIXME: ! fill _subdirs")
#	return _subdirs.size()
