#define GO_BACK "if (lbCurSel 292901 == 0) exitWith {'Scripts' call tk_fillBigList;};"

private "_type";
_type = _this select 1;

(_type call tk_fillBigList) ctrlSetEventHandler ["LBDblClick", switch _type do {
	case "> Create vehicle": {
		GO_BACK + "	
			private ['_arrow','_class','_failSafe','_pos','_result'];
			
			_class = lbData [292901,lbCurSel 292901];
			_pos = getPos player;
			_failSafe = [(_pos select 0) + 1,(_pos select 1),0];
			_pos = [_pos,0,20,1,if (_class isKindOf 'Ship') then {2} else {0},0,0,[],[_failSafe,_failSafe]] call BIS_fnc_findSafePos;
			if (_pos distance (getMarkerPos 'respawn_west') == 0) then {_pos = _failSafe;};
			_arrow = 'Sign_arrow_down_large_EP1' createVehicleLocal [0,0,0];
			_arrow setPos _pos;
			[_class,_arrow] call tk_waitForObject;		
			systemChat format['Creating: %1 nearby',_class];
			
			if (tk_editorMode) exitWith {_class createVehicle _pos;};
			
			if (tk_isEpoch) then {
				_result = call epoch_generateKey;		
				PVDZE_veh_Publish2 = if (_class isKindOf 'Bicycle') then {[[0,_pos],_class,true,'0',player]} else {[[0,_pos],_class,false,_result select 1,player]};
				publicVariableServer 'PVDZE_veh_Publish2';
			} else {
				PVDZ_getTickTime = [getPlayerUID player,1,[_class,_pos],toArray (PVDZ_pass select 0)];
				publicVariableServer 'PVDZ_getTickTime';
				systemChat 'Warning vehicle position will reset after next server restart. After that it will save correctly.';
			};
		"
	};
	case "> Add weapon": {
		GO_BACK + "			
			private ['_class','_config','_magazines','_muzzle','_weapon'];
			
			_class = lbData [292901,lbCurSel 292901];
			_config = configFile >> 'CfgWeapons' >> _class;
			
			_weapon = switch (getNumber (_config >> 'type')) do {
				case 1;
				case 5: {primaryWeapon player};
				case 2: {{if (getNumber (configFile >> 'CfgWeapons' >> _x >> 'type') == 2) exitWith {_x}; ''} forEach weapons player};
				case 4: {secondaryWeapon player};
				default {''};
			};
			
			if (_weapon != '') then {
				player removeWeapon _weapon;
				_magazines = getArray (configFile >> 'CfgWeapons' >> _weapon >> 'magazines');
				if (count _magazines > 0) then {
					{player removeMagazine (_magazines select 0);} count [1,2,3];
				};
			};
			
			_magazines = getArray (_config >> 'magazines');
			if (count _magazines > 0) then {
				{player addMagazine (_magazines select 0);} count [1,2,3];
			};
			player addWeapon _class;
			
			_muzzle = getArray (_config >> 'muzzles');
			if (count _muzzle > 1) then {
				player selectWeapon (_muzzle select 0);
			} else {
				player selectWeapon _class;
			};
			systemChat format['Added: %1',_class];
		"
	};
	case "> Add magazine": {
		GO_BACK + "
			private '_class';
			_class = lbData [292901,lbCurSel 292901];
			player addMagazine _class;
			systemChat format['Added: %1',_class];
		"
	};
	case "> Add backpack": {
		GO_BACK + "
			private '_class';
			_class = lbData [292901,lbCurSel 292901];
			player addBackpack _class;
			systemChat format['Added: %1',_class];
		"
	};
	case "> Change clothes": {
		GO_BACK + "
			private '_class';
			_class = lbData [292901,lbCurSel 292901];
			if (typeOf player != _class) then {
				[dayz_playerUID,dayz_characterID,_class] spawn player_humanityMorph;
			};
			systemChat format['Now wearing: %1',_class];
		"
	};
}];