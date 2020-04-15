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
class_name FileEntry

const TypeOfResource = preload("res://addons/OpenGRI/RageLib/Common/Resources/ResourceType.gd")

var _file: String
var Size: int
var SizeS: String
var ResourceType: TypeOfResource
var IsResourceFile: bool
var _resourceFiles = [".wtd", ".wdr", ".wdd", ".wft",
					  ".wpfl", ".whm", ".wad", ".wbd", 
					  ".wbn", ".wbs"]

func _init(context#FixCyclicRef: RealContext
		, file: String):
	Context = context
	_file = file
	Name = _file.get_file()
	
	var fs = File.new()
	fs.open(_file, File.READ)
	Size = fs.get_len()
	
	var ext = "." + Name.get_extension()
	#if _resourceFiles.has(ext):
	#	print("#FIXME: Open file stream, read resource header and type for ext="+ext)
	
	fs.close()
	
	var size_short = float(Size)
	var dimension = 0
	while (size_short > 1024):
		dimension = dimension + 1
		size_short = size_short / 1024
	
	SizeS = str(size_short).left(4)
#	var length = size_short.length()
#	while (length != 4):
#		length = length + 1
#		size_short = " "+size_short
	
	if SizeS.right(3) == ".":
		SizeS = SizeS.left(3)
	if dimension == 0:
		dimension = " B"
	elif dimension == 1:
		dimension = " KB"
	elif dimension == 2:
		dimension = " MB"
	elif dimension == 3:
		dimension = " GB"
	elif dimension == 4:
		dimension = " TB"
	elif dimension > 4:
		dimension = " *B"
	SizeS = SizeS + dimension
#	print("Name="+Name+" Size="+str(Size)+" SizeS="+SizeS)


func IsDirectory() -> bool:
	return false

func FullName() -> String:
	return _file

#func Size() -> int:
#	return Size

func GetData() -> PoolByteArray:
	var file = File.new()
	file.open(_file, File.READ)
	var content = file.get_buffer(file.get_len())
	file.close()
	return content

func SetData(data: PoolByteArray) -> void:
	var file = File.new()
	file.open(_file, File.WRITE)
	file.store_buffer(data)
	file.close()
