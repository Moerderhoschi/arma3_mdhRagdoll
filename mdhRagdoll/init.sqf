//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MDH RAGDOLL AI UNITS GET MORE DAMAGE AT HIT & AI UNITS GET RAGDOLL EFFECT AT HIT(by Moerderhoschi) - v2025-04-14
// github: https://github.com/Moerderhoschi/arma3_mdhRagdoll
// steam mod version: https://steamcommunity.com/sharedfiles/filedetails/?id=3387437564
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if (missionNameSpace getVariable ["pAiGetMoreDamageAtHit",0] == 99 OR missionNameSpace getVariable ["pAiRagdollAtHit",99] == 99) then
{
	0 spawn
	{
		_valueCheck = 99;
		_defaultValue = 99;
		_path = 'mdhRagdoll';
		_env  = isServer;

		_diary  = 0;
		_mdhFnc = 0;

		if (hasInterface) then
		{
			_diary =
			{
				waitUntil {!(isNull player)};
				_c = true;
				_t = "MDH Ragdoll";
				if (player diarySubjectExists "MDH Mods") then
				{
					{
						if (_x#1 == _t) exitWith {_c = false}
					} forEach (player allDiaryRecords "MDH Mods");
				}
				else
				{
					player createDiarySubject ["MDH Mods","MDH Mods"];
				};
		
				if(_c) then
				{
					player createDiaryRecord
					[
						"MDH Mods",
						[
							_t,
							(
							  '<br/>MDH Ragdoll is a mod, created by Moerderhoschi for Arma 3.<br/>'
							+ '<br/>'
							+ 'All AI units hit by weapons will start ragdolling<br/>'
							+ '<br/>'
							+ 'If you have any question you can contact me at the steam workshop page.<br/>'
							+ '<br/>'
							+ '<img image="'+_path+'\mdhRagdoll.paa"/>'					  
							+ '<br/>'
							+ 'Credits and Thanks:<br/>'
							+ 'Armed-Assault.de Crew - For many great ArmA moments in many years<br/>'
							+ 'BIS - For ArmA3<br/>'
							)
						]
					]
				};
				true
			};
		};

		if (_env) then
		{
			_mdhFnc =
			{
				{
					if (local _x && {alive _x} && {(_x getVariable ["mdhEnemyDamageEhForceSet",-1]) == -1} && {!(_x in allPlayers)}) then
					{
						_x setVariable ["mdhEnemyDamageEhForceSet",
						_x addEventHandler ["HandleDamage",
						{
							params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit", "_context"];
							if (missionNameSpace getVariable ["pAiRagdollAtHit",99] == 99) then
							{
								_u = _unit;
								if (_selection == "body" && {vehicle _u == _u} && {_directHit} && {lifeState _u != "INCAPACITATED"} && {alive _u}) then
								{
									if (!(_u getVariable ["mdhEnemyDamageEhForceHit",false])) then
									{
										_u setVariable ["mdhEnemyDamageEhForceHit",true];
										[_u] spawn
										{
											params ["_u"];
											if (!alive _u) exitWith {};
											_u addForce [[0,0,0], [0,0,0], false]; // reduce warping on ground
											sleep 3;
											if (!alive _u) exitWith {};
											_u setUnconscious true;

											if
											(
												missionNameSpace getVariable["mdhEnemyDamageEhForceOld",false] == true
											OR {profileNameSpace getVariable["mdhEnemyDamageEhForceOld",false] == true}
											)
											then
											{
												if (0.2 > random 1) then // stay longer Unconscious
												{
													_w = "";
													_t = primaryWeapon _u;
													if (secondaryWeapon _u != "") then 
													{
														_w = "Weapon_Empty" createVehicle [500,500,500];
														_u actionNow ["DropWeapon", _w, secondaryWeapon _u];
														_p = getPosWorld _u;
														_w setpos [(_p#0) + 0.3, _p#1, 0];
													};
													if (primaryWeapon _u != "") then 
													{
														_w = "Weapon_Empty" createVehicle [500,500,500];
														_u actionNow ["DropWeapon", _w, primaryWeapon _u];
														_p = getPosWorld _u;
														_w setpos [_p#0, _p#1, 0];
													};
													sleep 10; 
													sleep random 5;
													if (!alive _u) exitWith {};
			
													if (alive _u && {_t != ""}) then
													{
														_u actionNow ["TakeWeapon", _w, _t];
														_u selectWeapon primaryWeapon _u;
													};
												};
												_u setUnconscious false;
												sleep 5;
												_u setVariable ["mdhEnemyDamageEhForceHit",false];
												if (!alive _u) exitWith {};
												_u playMove "AmovPknlMstpSrasWrflDnon";
												_u selectWeapon primaryWeapon _u;
											}
											else
											{
												if (0.2 > random 1) then
												{
													_w = "";
													_t = primaryWeapon _u;
													if (secondaryWeapon _u != "") then 
													{
														_w = "Weapon_Empty" createVehicle [500,500,500];
														_u actionNow ["DropWeapon", _w, secondaryWeapon _u];
														_p = getPosWorld _u;
														_w setpos [(_p#0) + 0.3, _p#1, 0];
													};
													if (primaryWeapon _u != "") then 
													{
														_w = "Weapon_Empty" createVehicle [500,500,500];
														_u actionNow ["DropWeapon", _w, primaryWeapon _u];
														_p = getPosWorld _u;
														_w setpos [_p#0, _p#1, 0];
													};
													sleep 10; 
													sleep random 5;
													_u setUnconscious false;
													if (alive _u && {_t != ""}) then
													{
														_u actionNow ["TakeWeapon", _w, _t];
														_u selectWeapon primaryWeapon _u;
													};
													sleep 5;
													_u setVariable ["mdhEnemyDamageEhForceHit",false];
													if (!alive _u) exitWith {};
													_u playMove "AmovPknlMstpSrasWrflDnon";
													_u selectWeapon primaryWeapon _u;
												}
												else
												{
													_u disableConversation true;
													_u setvariable ["bis_nocoreconversations",true];											
													_u disableAI "FSM";
													_u disableAI "RADIOPROTOCOL";
													if (secondaryWeapon _u != "") then 
													{
														_w = "Weapon_Empty" createVehicle [500,500,500];
														_u actionNow ["DropWeapon", _w, secondaryWeapon _u];
														_p = getPosWorld _u;
														_w setpos [(_p#0) + 0.3, _p#1, 0];
													};
													if (primaryWeapon _u != "") then 
													{
														_w = "Weapon_Empty" createVehicle [500,500,500];
														_u actionNow ["DropWeapon", _w, primaryWeapon _u];
														_p = getPosWorld _u;
														_w setpos [_p#0, _p#1, 0];
													};
													sleep 120;
													sleep random 180;
													_u setDamage 1;
												};									
											};
										};
									};
								};
							};

							if
							(
								missionNameSpace getVariable ["pAiGetMoreDamageAtHit",0] == 99
							OR {missionNameSpace getVariable ["mdhEnemyDamageEhForceOld",false] == true}
							OR {profileNameSpace getVariable ["mdhEnemyDamageEhForceOld",false] == true}
							)
							then
							{
								_damage * 2
							}
						}]];
					};
				} forEach allUnits;
			};
		};

		if (hasInterface) then
		{
			uiSleep 0.6;
			call _diary;
		};

		sleep (2 + random 2);
		while {missionNameSpace getVariable ["pAiGetMoreDamageAtHit",0] == _valueCheck OR missionNameSpace getVariable ["pAiRagdollAtHit",_defaultValue] == _valueCheck} do
		{
			if (_env) then {call _mdhFnc};
			sleep (7 + random 3);
			if (hasInterface) then {call _diary};
		};
	};
};