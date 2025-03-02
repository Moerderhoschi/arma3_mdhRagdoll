///////////////////////////////////////////////////////////////////////////////////////////////////
// MDH RAGDOLL
// MADE BY MOERDERHOSCHI
// 12.2024
// Steam: https://steamcommunity.com/sharedfiles/filedetails/?id=3387437564
///////////////////////////////////////////////////////////////////////////////////////////////////
0 = [] spawn
{
	///////////////////////////////////////////////////////////////////////////////////////////////////
	// DIARYRECORD
	///////////////////////////////////////////////////////////////////////////////////////////////////
	_diary =
	{
		if (isNull player) exitWith {false};
		if(!(player diarySubjectExists "mdhRagdoll")) then
		{
			player createDiarySubject ["mdhRagdoll","MDH Ragdoll"];
			player createDiaryRecord
			[
				"mdhRagdoll",
				[
					"Ragdoll mod by Moerderhoschi",
					(
						'<br/>MDH Ragdoll is a mod, created by Moerderhoschi for Arma 3.<br/>'
					  + '<br/>'
					  + 'All AI units hit by weapons will start ragdolling<br/>'
					  + '<br/>'
					  + 'If you have any question you can contact me at the official Bohemia Interactive Forum: forums.bistudio.com<br/>'
					  + '<br/>'
					  + '<img image="mdhRagdoll\mdhRagdoll.paa"/>'					  
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
	
	///////////////////////////////////////////////////////
	// set function
	///////////////////////////////////////////////////////
	_mdhFunction =
	{
		{
			if (local _x && {alive _x} && {(_x getVariable ["mdhEnemyDamageEhForceSet",-1]) == -1} && {!(_x in allPlayers)}) then
			{
				_x setVariable ["mdhEnemyDamageEhForceSet",
				_x addEventHandler ["HandleDamage",
				{
					params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit", "_context"];
					_u = _unit;
					_s = _source;
					_v = getPosASL _s vectorFromTo getPosASL _u;
					_f = [(_v#0) * 1, (_v#1) * 1, 0];

					if (_selection == "body" && {vehicle _u == _u} && {_directHit} && {lifeState _u != "INCAPACITATED"}) then
					{
						if (!(_u getVariable ["mdhEnemyDamageEhForceHit",false])) then
						{
							_u setVariable ["mdhEnemyDamageEhForceHit",true];
							[_u, _f, _selection] spawn
							{
								_u = _this#0;
								_f = _this#1;
								_selection = _this#2;
								sleep 0.1;
								if (alive _u) then
								{
									_u addForce [_u vectorModelToWorld _f, _u selectionPosition _selection, true];
									sleep 3;

									if (missionNameSpace getVariable["mdhEnemyDamageEhForceOld",false] == true OR {profileNameSpace getVariable["mdhEnemyDamageEhForceOld",false] == true}) then
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

					if (!alive _u) then 
					{
						_u removeEventHandler ["HandleDamage", (_u getVariable ["mdhEnemyDamageEhForceSet",-1])];
						_u setVariable ["mdhEnemyDamageEhForceSet",nil];
					};

					if (missionNameSpace getVariable["mdhEnemyDamageEhForceOld",false] == true OR {profileNameSpace getVariable["mdhEnemyDamageEhForceOld",false] == true}) then {_damage * 2}
				}]];
				sleep 0.02;
			};

			if (_x in allPlayers && {!((_x getVariable ["mdhEnemyDamageEhForceSet",-1]) < 0)}) then // JIP Player take control of AI
			{
				_x removeEventHandler ["HandleDamage", (_x getVariable ["mdhEnemyDamageEhForceSet",-1])];
				_x setVariable ["mdhEnemyDamageEhForceSet",nil];
			};
		} forEach allUnits;
	};

	///////////////////////////////////////////////////////
	// loop
	///////////////////////////////////////////////////////
	sleep 1;

	while {sleep 1; true} do
	{
		sleep random 1;
		0 = [_diary, _mdhFunction] spawn
		{
			if (!isDedicated) then
			{
				waitUntil {!(isNull player)};
				waitUntil {player==player};
				0 = [] call (_this select 0);
			};
			0 = [] call (_this select 1);
		};
		sleep 5;
	};
};