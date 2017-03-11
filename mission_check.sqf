//Temporary check for A2OA mission override exploit.
//This bug should be fixed in the next EOL patch.
//Put this code at the bottom of dayz_server\init\server_functions.sqf

//List all files in your mission. For example, you may need to add 'custom\variables.sqf', etc.
_files = ['description.ext','init.sqf','mission.sqm','rules.sqf'];

_list = [];
{
	_file = toArray (toLower(preprocessFile _x));
	_sum = 0;
	_count = {_sum = _sum + _x; true} count _file;
	_sum = _sum min 999999;		
	_list set [count _list,[_count,_sum]];
} forEach _files;

//Check mission integrity on all clients
_temp = "HeliHEmpty" createVehicle [0,0,0];
_temp setVehicleInit (str formatText["
	if (isServer) exitWith {};
	
	_list = [];
	{
		_file = toArray (toLower(preprocessFile _x));
		_sum = 0;
		_count = {_sum = _sum + _x; true} count _file;
		_sum = _sum min 999999;		
		_list set [count _list,[_count,_sum]];
	} forEach %1;
	
	_file = -1;
	{
		if ((_x select 0 != (_list select _forEachIndex) select 0) or (_x select 1 != (_list select _forEachIndex) select 1)) then {
			_file = _forEachIndex;
		};
	} forEach %2;

	if (_file != -1) then {
		MISSION_CHECK = if ((_list select _file) select 0 < 49999) then {preprocessFileLineNumbers (%1 select _file)} else {'TOO BIG'};
		publicVariableServer 'MISSION_CHECK';
		[] spawn {
			uiSleep 1;
			{(findDisplay _x) closeDisplay 2;} count [0,8,12,18,46,70];
		};
	};
",_files,_list]);

processInitCommands;