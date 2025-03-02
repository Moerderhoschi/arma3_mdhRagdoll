class CfgPatches 
{
	class mdhRagdoll
	{
		author = "Moerderhoschi";
		name = "mdhRagdoll";
		url = "http://moerderhoschi.bplaced.net";
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {};
		version = "1.20160815";
		versionStr = "1.20160815";
		versionAr[] = {1,20160816};
		authors[] = {};
	};
};

class CfgFunctions
{
	class mdh
	{
		class mdhFunctions
		{
			class mdhRagdoll
			{
				file = "mdhRagdoll\init.sqf";
				postInit = 1;
			};
		};
	};
};

class CfgMods
{
	class mdhRagdoll
	{
		dir = "@mdhRagdoll";
		name = "mdhRagdoll";
		picture = "mdhRagdoll\mdhRagdoll.paa";
		hidePicture = "true";
		hideName = "true";
		actionName = "Website";
		action = "http://moerderhoschi.bplaced.net";
	};
};