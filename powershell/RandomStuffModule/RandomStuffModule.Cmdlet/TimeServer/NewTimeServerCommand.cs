using Microsoft.Win32;
using System.Linq;
using System.Management.Automation;


namespace RandomStuffModule.Cmdlet.TimeServer;

[Cmdlet(VerbsCommon.New, "TimeServer")]
[OutputType(typeof(RegeditEntry))]
public class NewTimeServerCommand : PSCmdlet
{
    [Parameter(
        Mandatory = true,
        Position = 0,
        ValueFromPipeline = true,
        ValueFromPipelineByPropertyName = true)]
    public string ComputerName { get; set; }

    [Parameter(
        Position = 1,
        ValueFromPipelineByPropertyName = true)]
    public SwitchParameter Default { get; set; } = false;
    private string registryKeyString;

    protected override void BeginProcessing()
    {
        registryKeyString = @"SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers";
        WriteVerbose("Begin!");
        WriteVerbose($"opening {registryKeyString}");
    }
    protected override void ProcessRecord()
    {
        using var key = Registry.LocalMachine.OpenSubKey(registryKeyString, RegistryKeyPermissionCheck.ReadWriteSubTree);
        int oldKeyCount = key.ValueCount;

        key.SetValue(oldKeyCount.ToString(), ComputerName);
        if (Default.IsPresent)
            key.SetValue(key.GetValueNames().First(), oldKeyCount.ToString());
        WriteObject(new RegeditEntry
        {
            Name = oldKeyCount,
            Value = ComputerName,
            Default = Default.IsPresent
        });
    }
    protected override void EndProcessing()
    {
        WriteVerbose("End!");
    }
}

