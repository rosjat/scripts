using System.Linq;
using Microsoft.Win32;
using System.Collections.Generic;


namespace RandomStuffModule.Cmdlet.TimeServer;


public static class TimeServer
{
	private readonly static string registryKeyString = @"SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers"; 
	public static List<RegeditEntry> GetEntries()
    {
        List<RegeditEntry> entries = new();
        using var key = Registry.LocalMachine.OpenSubKey(registryKeyString, RegistryKeyPermissionCheck.ReadSubTree);
        var valNames = key.GetValueNames().ToList();
        var defaultValue = key.GetValue(valNames.First().Trim()).ToString();
        foreach (var valName in valNames)
        {
            if(string.IsNullOrEmpty(valName)) // we skip the default value !
                continue;
            entries.Add(new RegeditEntry
            {
                Name = int.Parse(valName),
                Value = key.GetValue(valName).ToString(),
                Default = defaultValue.Equals(valName.Trim())
            });
        }
        return entries;
    }
	
	public static RegeditEntry Add(string computerName,bool isDefault)
	{
		using var key = Registry.LocalMachine.OpenSubKey(registryKeyString, RegistryKeyPermissionCheck.ReadWriteSubTree);
        int oldKeyCount = key.ValueCount;
        key.SetValue(oldKeyCount.ToString(), computerName);
        if (isDefault)
            key.SetValue(key.GetValueNames().First(), oldKeyCount.ToString());
        return new RegeditEntry
        {
            Name = oldKeyCount,
            Value = computerName,
            Default = isDefault
        };
	}
	public static RegeditEntry Get(string computerName)
    {
        return GetEntries().First(e => e.Value.Equals(computerName));
    }

	public static RegeditEntry Set(string oldValue, string newValue, bool isDefault)
	{
		using var key = Registry.LocalMachine.OpenSubKey(registryKeyString, RegistryKeyPermissionCheck.ReadWriteSubTree);
		var entry = GetEntries().FirstOrDefault(e => e.Value.Equals(oldValue));
		if(entry != null)
		{
				key.SetValue(entry.Name.ToString(), newValue);
				if (isDefault)
					key.SetValue(key.GetValueNames().First(), entry.Name.ToString());
		}
		return GetEntries().FirstOrDefault(e => e.Value.Equals(newValue));
	}

	public static void Remove(string computerName)
	{
		using var key = Registry.LocalMachine.OpenSubKey(registryKeyString, RegistryKeyPermissionCheck.ReadWriteSubTree);
		var entry = GetEntries().FirstOrDefault(e => e.Value.Equals(computerName));
		var isDefault = entry.Default;
		key.DeleteValue(entry.Name.ToString());
		if (isDefault)
			key.SetValue(key.GetValueNames().First(), key.ValueCount - 1);
	}
}