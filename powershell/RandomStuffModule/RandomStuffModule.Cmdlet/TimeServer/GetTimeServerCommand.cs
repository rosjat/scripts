using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;


namespace RandomStuffModule.Cmdlet.TimeServer;

[Cmdlet(VerbsCommon.Get, "TimeServer")]
[OutputType(typeof(RegeditEntry))]
public class GetTimeServerCommand : PSCmdlet
{
    [Parameter(
        Position = 0,
        ValueFromPipeline = true,
        ValueFromPipelineByPropertyName = true)]
    public string ComputerName { get; set; }

    private string registryKeyString;

    protected override void BeginProcessing()
    {
        registryKeyString = @"SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers";
        WriteVerbose("Begin!");
        WriteVerbose($"opening {registryKeyString}");
    }
    protected override void ProcessRecord()
    {
        WriteVerbose("Process start ... ");
        List<RegeditEntry> serverList = GetEntries();
        if (!string.IsNullOrEmpty(ComputerName) && serverList.Where(i => i.Value.Equals(ComputerName)).Any())
        {
            WriteVerbose($"Process: found entry for {ComputerName} ... ");
            serverList.Where(i => i.Value.Equals(ComputerName)).ToList().ForEach((e) => { WriteObject(e); WriteVerbose($"{e.Name.ToString()} -> {e.Value}"); });
        }
        else
            serverList.ForEach((e) => { WriteObject(e); WriteVerbose($"{e.Name.ToString()} -> {e.Value}"); });
        WriteVerbose("Process end ... ");
    }
    protected override void EndProcessing()
    {
        WriteVerbose("End!");
    }

    private List<RegeditEntry> GetEntries()
    {
        WriteVerbose("GetEntries start ... ");
        List<RegeditEntry> entries = new();
        using var key = Registry.LocalMachine.OpenSubKey(registryKeyString, RegistryKeyPermissionCheck.ReadSubTree);
        var valNames = key.GetValueNames().ToList();
        var defaultValue = key.GetValue(valNames.First().Trim()).ToString();
        WriteVerbose($"default ->  {defaultValue} ");
        foreach (var valName in valNames)
        {
            if(string.IsNullOrEmpty(valName)) // we skip the default value !
                continue;
            WriteVerbose($"{int.Parse(valName)} -> {key.GetValue(valName).ToString()}]");
            entries.Add(new RegeditEntry
            {
                Name = int.Parse(valName),
                Value = key.GetValue(valName).ToString(),
                Default = defaultValue.Equals(valName.Trim())
            });
        }
        WriteVerbose("GetEntries end ... ");
        return entries;
    }
}
