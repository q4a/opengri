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

extends Object
class_name FileSystem

var RootDirectory: FSDirectory

#public abstract void Open(string filename);
#public abstract void Save();
#public abstract void Rebuild();
#public abstract void Close();
#public abstract bool SupportsRebuild { get; }
#public abstract bool HasDirectoryStructure { get; }

func DumpFSToDebug() -> void:
	DumpDirToDebug("", RootDirectory)

func DumpDirToDebug(indent: String, dir: FSDirectory) -> void:
	print("Debug: " + indent + dir.Name)
	indent += "  "
	for item in dir:
		if item.IsDirectory():
			DumpDirToDebug(indent, item)
		else:
			print("Debug: " + indent + item.Name + " (Size: " + item.Size + ", Compressed: " + item.IsCompressed + ")")
