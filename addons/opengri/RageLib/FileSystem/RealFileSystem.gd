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
var _customData: Dictionary # of {String: PoolByteArray}
var _realDirectory: String

func Open(filename: String) -> void:
	_realDirectory = filename
	_context = RealContext.new(filename)
	
	BuildFS()

func BuildFSDirectory(dirEntry#FixCyclicRef: DirectoryEntry
					, fsDirectory: FSDirectory) -> void:
	fsDirectory.Name = dirEntry.Name
#	print("dirEntry.Name="+dirEntry.Name)
	
	var dir = Directory.new()
	dir.open(dirEntry._directory)
	dir.list_dir_begin(true, false)
	var file_name = dir.get_next()
	
	var path
	while file_name != "":
		path = dirEntry._directory + "/" + file_name
		
		if dir.current_is_dir():
			var sub_dir = FSDirectory.new()
			BuildFSDirectory(dirEntry.GetDirectory(path), sub_dir)
			sub_dir.ParentDirectory = fsDirectory
			fsDirectory.AddObject(sub_dir)
		else:
			var fileEntry = dirEntry.GetFile(path)
			
			var file = FSFile.new(_customData, fileEntry)
			
			file.CompressedSize = fileEntry.Size
			file.IsCompressed = false
			file.Name = fileEntry.Name
			file.Size = fileEntry.Size
			file.IsResource = fileEntry.IsResourceFile # default: false
			file.ResourceType = fileEntry.ResourceType # default: null
			file.ParentDirectory = fsDirectory
			
			fsDirectory.AddObject(file)
			
#			print("RealFileSystem._customData.size()="+str(_customData.size()))
#			print("fileEntry.Name="+fileEntry.Name)
#			print("fileEntry.Size="+str(fileEntry.Size))
#			print("fileEntry.IsResourceFile="+str(fileEntry.IsResourceFile))
#			print("fileEntry.ResourceType="+str(fileEntry.ResourceType))
#			print("fsDirectory="+str(fsDirectory))
		
		file_name = dir.get_next()
		
	dir.list_dir_end()

func BuildFS() -> void:
	RootDirectory = FSDirectory.new()
	BuildFSDirectory(_context.RootDirectory, RootDirectory)
