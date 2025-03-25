//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MDH RAGDOLL AI UNITS GET MORE DAMAGE AT HIT & AI UNITS GET RAGDOLL EFFECT AT HIT(by Moerderhoschi) - v2025-03-20
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
				//systemChat ("Ragdoll start");
				{
					if (local _x && {alive _x} && {(_x getVariable ["mdhEnemyDamageEhForceSet",-1]) == -1} && {!(_x in allPlayers)}) then
					{
						//systemChat ("Ragdoll added to "+str(_x));
						_x setVariable ["mdhEnemyDamageEhForceSet",
						_x addEventHandler ["HandleDamage",
						{
							params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit", "_context"];
							if (missionNameSpace getVariable ["pAiRagdollAtHit",99] == 99) then
							{
								_u = _unit;
								_s = _source;
								_v = getPosASL _s vectorFromTo getPosASL _u;
								_f = [(_v#0) * 1, (_v#1) * 1, 0];
				
								if (_selection == "body" && {vehicle _u == _u} && {_directHit} && {lifeState _u != "INCAPACITATED"} && {alive _u}) then
								{
									if (!(_u getVariable ["mdhEnemyDamageEhForceHit",false])) then
									{
										_u setVariable ["mdhEnemyDamageEhForceHit",true];
										[_u, _f, _selection] spawn
										{
											params ["_u", "_f", "_selection"];
											sleep 0.1;
											_u addForce [_u vectorModelToWorld _f, _u selectionPosition _selection, true];
											sleep 3;

											if
											(
												missionNameSpace getVariable["mdhEnemyDamageEhForceOld",false] == true
											OR {profileNameSpace getVariable["mdhEnemyDamageEhForceOld",false] == true}
											)
											then
											{
												if (0.2 > random 1) then // stay longer Unconscious
												{
													sleep 10; 
													sleep random 5;
												};
			
												_u setUnconscious false;
												sleep 5;
												_u setVariable ["mdhEnemyDamageEhForceHit",false];
												_u playMove "AmovPknlMstpSrasWrflDnon";
											}
											else
											{
												if (0.2 > random 1) then
												{
													sleep 10; 
													sleep random 5;
													_u setUnconscious false;
													sleep 5;
													_u setVariable ["mdhEnemyDamageEhForceHit",false];
													_u playMove "AmovPknlMstpSrasWrflDnon";
												}
												else
												{
													_u disableConversation true;
													_u setvariable ["bis_nocoreconversations",true];											
													_u disableAI "FSM";
													_u disableAI "RADIOPROTOCOL";
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
				//systemChat ("Ragdoll End");
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